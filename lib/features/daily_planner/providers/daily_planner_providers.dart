import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/models.dart';

const _uuid = Uuid();

/// Default duration for cases without a specified duration (in minutes).
/// Used for conflict detection and timeline visualization.
const int kDefaultCaseDurationMinutes = 60;

/// State for the Daily Planner.
class DailyPlannerState {
  DailyPlannerState({
    this.anaesthesiologists = const [],
    this.surgeonGroups = const [],
    this.cases = const [],
  });

  final List<Anaesthesiologist> anaesthesiologists;
  final List<PlannerSurgeonGroup> surgeonGroups;
  final List<PlannerCase> cases;

  DailyPlannerState copyWith({
    List<Anaesthesiologist>? anaesthesiologists,
    List<PlannerSurgeonGroup>? surgeonGroups,
    List<PlannerCase>? cases,
  }) {
    return DailyPlannerState(
      anaesthesiologists: anaesthesiologists ?? this.anaesthesiologists,
      surgeonGroups: surgeonGroups ?? this.surgeonGroups,
      cases: cases ?? this.cases,
    );
  }

  /// Get main anaesthesiologists (not helpers).
  List<Anaesthesiologist> get mainAnaesthesiologists =>
      anaesthesiologists.where((a) => !a.isHelper).toList();

  /// Get helper anaesthesiologists.
  List<Anaesthesiologist> get helperAnaesthesiologists =>
      anaesthesiologists.where((a) => a.isHelper).toList();

  /// Get surgeon groups for a specific anaesthesiologist.
  List<PlannerSurgeonGroup> surgeonGroupsFor(String anaesthesiologistId) {
    return surgeonGroups
        .where((g) => g.anaesthesiologistId == anaesthesiologistId)
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  /// Get cases for a specific surgeon group.
  List<PlannerCase> casesFor(String surgeonGroupId) {
    return cases.where((c) => c.surgeonGroupId == surgeonGroupId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  /// Get all cases for an anaesthesiologist (across all their surgeon groups).
  List<PlannerCase> allCasesForAnaesthesiologist(String anaesthesiologistId) {
    final groupIds = surgeonGroups
        .where((g) => g.anaesthesiologistId == anaesthesiologistId)
        .map((g) => g.id)
        .toSet();
    return cases.where((c) => groupIds.contains(c.surgeonGroupId)).toList();
  }

  /// Parse time string (HH:mm) to minutes from midnight.
  static int? parseTimeToMinutes(String? time) {
    if (time == null || time.isEmpty) return null;
    try {
      final parts = time.split(':').map(int.parse).toList();
      return parts[0] * 60 + (parts.length > 1 ? parts[1] : 0);
    } catch (e) {
      return null;
    }
  }

  /// Detect scheduling conflicts for an anaesthesiologist.
  /// Returns a map of caseId -> list of conflicts.
  Map<String, List<CaseConflict>> conflictsForAnaesthesiologist(
      String anaesthesiologistId) {
    final allCases = allCasesForAnaesthesiologist(anaesthesiologistId);
    final conflicts = <String, List<CaseConflict>>{};

    // Filter cases with valid start time (duration defaults if not set)
    final validCases = allCases.where((c) {
      final start = parseTimeToMinutes(c.startTime);
      return start != null;
    }).toList();

    // Sort by start time
    validCases.sort((a, b) {
      final aStart = parseTimeToMinutes(a.startTime)!;
      final bStart = parseTimeToMinutes(b.startTime)!;
      return aStart.compareTo(bStart);
    });

    // Check each case against subsequent cases for overlaps
    for (int i = 0; i < validCases.length; i++) {
      final caseA = validCases[i];
      final aStart = parseTimeToMinutes(caseA.startTime)!;
      final aDuration = caseA.durationMinutes ?? kDefaultCaseDurationMinutes;
      final aEnd = aStart + aDuration;

      for (int j = i + 1; j < validCases.length; j++) {
        final caseB = validCases[j];
        final bStart = parseTimeToMinutes(caseB.startTime)!;
        final bDuration = caseB.durationMinutes ?? kDefaultCaseDurationMinutes;
        final bEnd = bStart + bDuration;

        // Check for overlap: A ends after B starts AND B ends after A starts
        if (aEnd > bStart && bEnd > aStart) {
          final overlapStart = aStart > bStart ? aStart : bStart;
          final overlapEnd = aEnd < bEnd ? aEnd : bEnd;
          final overlapMinutes = overlapEnd - overlapStart;

          final conflict = CaseConflict(
            caseId: caseA.id,
            conflictingCaseId: caseB.id,
            overlapMinutes: overlapMinutes,
            message:
                '${caseA.patientName ?? "Case"} overlaps with ${caseB.patientName ?? "another case"} by $overlapMinutes min',
          );

          final reverseConflict = CaseConflict(
            caseId: caseB.id,
            conflictingCaseId: caseA.id,
            overlapMinutes: overlapMinutes,
            message:
                '${caseB.patientName ?? "Case"} overlaps with ${caseA.patientName ?? "another case"} by $overlapMinutes min',
          );

          conflicts.putIfAbsent(caseA.id, () => []).add(conflict);
          conflicts.putIfAbsent(caseB.id, () => []).add(reverseConflict);
        }
      }
    }

    return conflicts;
  }

  /// Check if a specific case has conflicts.
  bool caseHasConflict(String caseId, String anaesthesiologistId) {
    final conflicts = conflictsForAnaesthesiologist(anaesthesiologistId);
    return conflicts.containsKey(caseId);
  }

  /// Get time blocks for Gantt chart visualization.
  List<CaseTimeBlock> timeBlocksForAnaesthesiologist(String anaesthesiologistId) {
    final allCases = allCasesForAnaesthesiologist(anaesthesiologistId);
    final conflicts = conflictsForAnaesthesiologist(anaesthesiologistId);
    final blocks = <CaseTimeBlock>[];

    for (final c in allCases) {
      final startMinutes = parseTimeToMinutes(c.startTime);
      if (startMinutes == null) continue;

      // Get surgeon name for this case
      final group = surgeonGroups.firstWhere(
        (g) => g.id == c.surgeonGroupId,
        orElse: () => PlannerSurgeonGroup(
          id: '',
          anaesthesiologistId: '',
          exportedAt: DateTime.now(),
        ),
      );

      blocks.add(CaseTimeBlock(
        caseId: c.id,
        patientName: c.patientName ?? 'Unknown',
        operation: c.operation,
        startMinutes: startMinutes,
        durationMinutes: c.durationMinutes ?? kDefaultCaseDurationMinutes,
        hasConflict: conflicts.containsKey(c.id),
        surgeonName: group.surgeonName,
      ));
    }

    // Sort by start time
    blocks.sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    return blocks;
  }

  /// Get the anaesthesiologist ID for a given surgeon group.
  String? anaesthesiologistIdForGroup(String surgeonGroupId) {
    final group = surgeonGroups.cast<PlannerSurgeonGroup?>().firstWhere(
          (g) => g?.id == surgeonGroupId,
          orElse: () => null,
        );
    return group?.anaesthesiologistId;
  }
}


/// State notifier for the Daily Planner.
class DailyPlannerNotifier extends Notifier<DailyPlannerState> {
  @override
  DailyPlannerState build() => DailyPlannerState();

  // ===== ANAESTHESIOLOGIST METHODS =====

  /// Add a new anaesthesiologist.
  String addAnaesthesiologist(String name, {bool isHelper = false}) {
    final id = _uuid.v4();
    final anaesthesiologist = Anaesthesiologist(
      id: id,
      name: name,
      isHelper: isHelper,
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      anaesthesiologists: [...state.anaesthesiologists, anaesthesiologist],
    );

    return id;
  }

  /// Update an anaesthesiologist's name.
  void updateAnaesthesiologist(String id, String newName) {
    state = state.copyWith(
      anaesthesiologists: state.anaesthesiologists.map((a) {
        if (a.id == id) {
          return a.copyWith(name: newName);
        }
        return a;
      }).toList(),
    );
  }

  /// Delete an anaesthesiologist and all their surgeon groups.
  void deleteAnaesthesiologist(String id) {
    // Get all surgeon groups for this anaesthesiologist
    final groupIds = state.surgeonGroups
        .where((g) => g.anaesthesiologistId == id)
        .map((g) => g.id)
        .toSet();

    state = state.copyWith(
      anaesthesiologists: state.anaesthesiologists.where((a) => a.id != id).toList(),
      surgeonGroups: state.surgeonGroups
          .where((g) => g.anaesthesiologistId != id)
          .toList(),
      cases: state.cases.where((c) => !groupIds.contains(c.surgeonGroupId)).toList(),
    );
  }

  // ===== SURGEON GROUP METHODS =====

  /// Add a surgeon group to an anaesthesiologist.
  String addSurgeonGroup({
    required String anaesthesiologistId,
    String? surgeonName,
    String? hospital,
    String? startTime,
    String? sourceFileName,
    String? waitingRoomGroupId,
  }) {
    final id = _uuid.v4();
    final existingGroups = state.surgeonGroupsFor(anaesthesiologistId);
    
    final group = PlannerSurgeonGroup(
      id: id,
      anaesthesiologistId: anaesthesiologistId,
      surgeonName: surgeonName,
      hospital: hospital,
      startTime: startTime,
      sourceFileName: sourceFileName,
      exportedAt: DateTime.now(),
      orderIndex: existingGroups.length,
      waitingRoomGroupId: waitingRoomGroupId,
    );

    state = state.copyWith(
      surgeonGroups: [...state.surgeonGroups, group],
    );

    return id;
  }


  /// Update a surgeon group.
  void updateSurgeonGroup(PlannerSurgeonGroup updatedGroup) {
    state = state.copyWith(
      surgeonGroups: state.surgeonGroups.map((g) {
        if (g.id == updatedGroup.id) return updatedGroup;
        return g;
      }).toList(),
    );
  }

  /// Delete a surgeon group and all its cases.
  void deleteSurgeonGroup(String id) {
    state = state.copyWith(
      surgeonGroups: state.surgeonGroups.where((g) => g.id != id).toList(),
      cases: state.cases.where((c) => c.surgeonGroupId != id).toList(),
    );
  }

  /// Sort surgeon groups by time within an anaesthesiologist.
  void sortSurgeonGroupsByTime(String anaesthesiologistId) {
    final groups = state.surgeonGroups
        .where((g) => g.anaesthesiologistId == anaesthesiologistId)
        .toList();

    groups.sort((a, b) => _compareStartTimes(a.startTime, b.startTime));

    final updatedGroups = state.surgeonGroups.map((g) {
      if (g.anaesthesiologistId == anaesthesiologistId) {
        final newIndex = groups.indexWhere((sg) => sg.id == g.id);
        return g.copyWith(orderIndex: newIndex);
      }
      return g;
    }).toList();

    state = state.copyWith(surgeonGroups: updatedGroups);
  }

  // ===== CASE METHODS =====

  /// Add a case to a surgeon group.
  String addCase({
    required String surgeonGroupId,
    String? patientName,
    String? patientAge,
    String? patientGender,
    String? operation,
    String? startTime,
    int? durationMinutes,
    String? medicalAid,
    List<String> icd10Codes = const [],
    String? hospital,
    String? notes,
  }) {
    final id = _uuid.v4();
    final existingCases = state.casesFor(surgeonGroupId);

    final plannerCase = PlannerCase(
      id: id,
      surgeonGroupId: surgeonGroupId,
      patientName: patientName,
      patientAge: patientAge,
      patientGender: patientGender,
      operation: operation,
      startTime: startTime,
      durationMinutes: durationMinutes,
      medicalAid: medicalAid,
      icd10Codes: icd10Codes,
      hospital: hospital,
      notes: notes,
      orderIndex: existingCases.length,
    );

    state = state.copyWith(cases: [...state.cases, plannerCase]);

    return id;
  }

  /// Update a case.
  void updateCase(PlannerCase updatedCase) {
    state = state.copyWith(
      cases: state.cases.map((c) {
        if (c.id == updatedCase.id) return updatedCase;
        return c;
      }).toList(),
    );
  }

  /// Delete a case.
  void deleteCase(String id) {
    state = state.copyWith(
      cases: state.cases.where((c) => c.id != id).toList(),
    );
  }

  /// Sort cases by time within a surgeon group.
  void sortCasesByTime(String surgeonGroupId) {
    final groupCases =
        state.cases.where((c) => c.surgeonGroupId == surgeonGroupId).toList();

    groupCases.sort((a, b) => _compareStartTimes(a.startTime, b.startTime));

    final updatedCases = state.cases.map((c) {
      if (c.surgeonGroupId == surgeonGroupId) {
        final newIndex = groupCases.indexWhere((gc) => gc.id == c.id);
        return c.copyWith(orderIndex: newIndex);
      }
      return c;
    }).toList();

    state = state.copyWith(cases: updatedCases);
  }

  /// Sort all cases for an anaesthesiologist across all their surgeon groups.
  void sortAllCasesForAnaesthesiologist(String anaesthesiologistId) {
    // Get all surgeon group IDs for this anaesthesiologist
    final groupIds = state.surgeonGroups
        .where((g) => g.anaesthesiologistId == anaesthesiologistId)
        .map((g) => g.id)
        .toSet();

    // Get all cases for these groups
    final allCases =
        state.cases.where((c) => groupIds.contains(c.surgeonGroupId)).toList();

    // Sort by start time
    allCases.sort((a, b) => _compareStartTimes(a.startTime, b.startTime));

    // Update order indices
    final updatedCases = state.cases.map((c) {
      if (groupIds.contains(c.surgeonGroupId)) {
        final newIndex = allCases.indexWhere((ac) => ac.id == c.id);
        return c.copyWith(orderIndex: newIndex);
      }
      return c;
    }).toList();

    state = state.copyWith(cases: updatedCases);

    // Also sort surgeon groups by their first case's start time
    sortSurgeonGroupsByTime(anaesthesiologistId);
  }

  /// Move a case to a different anaesthesiologist.
  /// Creates a new surgeon group for the case under the target anaesthesiologist.
  void moveCaseToAnaesthesiologist({
    required String caseId,
    required String targetAnaesthesiologistId,
    String? targetSurgeonGroupId,
  }) {
    final caseToMove = state.cases.cast<PlannerCase?>().firstWhere(
          (c) => c?.id == caseId,
          orElse: () => null,
        );
    if (caseToMove == null) return;

    // Get the original surgeon group to copy surgeon info
    final originalGroup = state.surgeonGroups.cast<PlannerSurgeonGroup?>().firstWhere(
          (g) => g?.id == caseToMove.surgeonGroupId,
          orElse: () => null,
        );

    String groupId;

    if (targetSurgeonGroupId != null) {
      // Move to existing surgeon group
      groupId = targetSurgeonGroupId;
    } else {
      // Create a new surgeon group for this case under the target anaesthesiologist
      groupId = addSurgeonGroup(
        anaesthesiologistId: targetAnaesthesiologistId,
        surgeonName: originalGroup?.surgeonName ?? 'Transferred Case',
        hospital: originalGroup?.hospital ?? caseToMove.hospital,
        startTime: caseToMove.startTime,
      );
    }

    // Update the case to point to the new surgeon group
    final updatedCase = caseToMove.copyWith(
      surgeonGroupId: groupId,
      orderIndex: state.casesFor(groupId).length,
    );

    state = state.copyWith(
      cases: state.cases.map((c) {
        if (c.id == caseId) return updatedCase;
        return c;
      }).toList(),
    );
  }


  // ===== HELPER METHODS =====

  /// Compare two start time strings (HH:mm format).
  int _compareStartTimes(String? a, String? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;

    try {
      final aParts = a.split(':').map(int.parse).toList();
      final bParts = b.split(':').map(int.parse).toList();

      final aMinutes = aParts[0] * 60 + (aParts.length > 1 ? aParts[1] : 0);
      final bMinutes = bParts[0] * 60 + (bParts.length > 1 ? bParts[1] : 0);

      return aMinutes.compareTo(bMinutes);
    } catch (e) {
      return a.compareTo(b);
    }
  }

  /// Clear all data.
  void clearAll() {
    state = DailyPlannerState();
  }
}

/// Provider for the Daily Planner state.
final dailyPlannerProvider =
    NotifierProvider<DailyPlannerNotifier, DailyPlannerState>(
  DailyPlannerNotifier.new,
);
