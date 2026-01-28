import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/models.dart';

const _uuid = Uuid();

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
