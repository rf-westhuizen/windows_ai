import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/models/models.dart';
import '../data/services/services.dart';

const _uuid = Uuid();

/// Provider for the OpenAI API key.
final waitingRoomApiKeyProvider = Provider<String>((ref) {
  final key = dotenv.env['OPENAI_API_KEY'];
  if (key == null || key.isEmpty || key == 'your_openai_api_key_here') {
    throw Exception('OPENAI_API_KEY not configured in .env file');
  }
  return key;
});

/// Provider for the surgical extraction service.
final surgicalExtractionServiceProvider =
    Provider<SurgicalExtractionService>((ref) {
  final apiKey = ref.watch(waitingRoomApiKeyProvider);
  return SurgicalExtractionService(apiKey: apiKey);
});

/// Provider for the PDF service.
final waitingRoomPdfServiceProvider = Provider<PdfExtractionService>((ref) {
  return PdfExtractionService();
});

/// Combined state for the waiting room.
class WaitingRoomState {
  WaitingRoomState({
    this.groups = const [],
    this.cases = const [],
    this.isProcessing = false,
    this.processingFileName,
    this.error,
  });

  final List<SurgeonGroup> groups;
  final List<SurgicalCase> cases;
  final bool isProcessing;
  final String? processingFileName;
  final String? error;

  WaitingRoomState copyWith({
    List<SurgeonGroup>? groups,
    List<SurgicalCase>? cases,
    bool? isProcessing,
    String? processingFileName,
    String? error,
  }) {
    return WaitingRoomState(
      groups: groups ?? this.groups,
      cases: cases ?? this.cases,
      isProcessing: isProcessing ?? this.isProcessing,
      processingFileName: processingFileName,
      error: error,
    );
  }

  /// Get all cases belonging to a specific group.
  List<SurgicalCase> casesForGroup(String groupId) {
    return cases.where((c) => c.groupId == groupId).toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));
  }

  /// Check if a case can be reattached (was detached from another group).
  bool canReattach(SurgicalCase surgicalCase) {
    return surgicalCase.groupId != surgicalCase.originalGroupId &&
        groups.any((g) => g.id == surgicalCase.originalGroupId);
  }

  /// Get active (non-exported) groups.
  List<SurgeonGroup> get activeGroups =>
      groups.where((g) => !g.isExported).toList();

  /// Get exported groups.
  List<SurgeonGroup> get exportedGroups =>
      groups.where((g) => g.isExported).toList();
}

/// State notifier for managing the waiting room.
class WaitingRoomNotifier extends Notifier<WaitingRoomState> {
  @override
  WaitingRoomState build() => WaitingRoomState();

  /// Process a dropped file and extract surgical cases.
  Future<void> processFile(String filePath, String fileName) async {
    print('🟡 [WaitingRoom] Processing file: $fileName');

    state = state.copyWith(
      isProcessing: true,
      processingFileName: fileName,
      error: null,
    );

    try {
      final extractionService = ref.read(surgicalExtractionServiceProvider);
      final pdfService = ref.read(waitingRoomPdfServiceProvider);

      SurgicalExtractionResult result;
      final ext = fileName.toLowerCase().split('.').last;

      if (ext == 'pdf') {
        // Try text extraction first
        try {
          final text = await pdfService.extractText(filePath);
          print('🔵 [WaitingRoom] Text extraction successful, using text mode');
          result = await extractionService.extractFromText(text);
        } on InsufficientTextException catch (e) {
          // Fallback to Vision API for image-based PDFs
          print('🟡 [WaitingRoom] ${e.message}');
          print('🟡 [WaitingRoom] Falling back to Vision API...');
          final images = await pdfService.convertToImages(filePath);
          result = await extractionService.extractFromImageBytes(images);
        }
      } else {
        result = await extractionService.extractFromImage(filePath);
      }

      // Create a new group for this file
      final groupId = _uuid.v4();
      final group = SurgeonGroup(
        id: groupId,
        surgeonName: result.surgeonName,
        hospital: result.hospital,
        startTime: result.startTime,
        sourceFileName: fileName,
        createdAt: DateTime.now(),
      );

      // Create cases linked to this group
      final newCases = result.cases.asMap().entries.map((entry) {
        final index = entry.key;
        final extracted = entry.value;
        return SurgicalCase(
          id: _uuid.v4(),
          groupId: groupId,
          originalGroupId: groupId,
          patientName: extracted.patientName,
          patientAge: extracted.patientAge,
          operation: extracted.operation,
          startTime: extracted.startTime,
          durationMinutes: extracted.durationMinutes,
          medicalAid: extracted.medicalAid,
          icd10Codes: extracted.icd10Codes,
          hospital: extracted.hospital,
          notes: extracted.notes,
          orderIndex: index,
        );
      }).toList();

      state = state.copyWith(
        groups: [...state.groups, group],
        cases: [...state.cases, ...newCases],
        isProcessing: false,
      );

      print('🟢 [WaitingRoom] Created group with ${newCases.length} cases');
    } catch (e) {
      print('🔴 [WaitingRoom] Error: $e');
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  /// Detach a case from its group, creating a new group for it.
  /// 
  /// [newHospital] - Optional new hospital/location for the detached group.
  /// [newStartTime] - Optional new start time for the detached group.
  void detachCase(
    String caseId, {
    String? newHospital,
    String? newStartTime,
  }) {
    final surgicalCase = state.cases.firstWhere((c) => c.id == caseId);
    final originalGroup = state.groups.firstWhere(
      (g) => g.id == surgicalCase.groupId,
    );

    // Determine the hospital: user input > case hospital > group hospital
    final hospital = newHospital ?? 
        surgicalCase.hospital ?? 
        originalGroup.hospital;

    // Determine the start time: user input > case start time
    final startTime = newStartTime ?? surgicalCase.startTime;

    // Create a new group for this detached case
    final newGroupId = _uuid.v4();
    final newGroup = SurgeonGroup(
      id: newGroupId,
      surgeonName: originalGroup.surgeonName,
      hospital: hospital,
      startTime: startTime,
      sourceFileName: '${originalGroup.sourceFileName} (detached)',
      isDetached: true,
      detachedFromGroupId: surgicalCase.originalGroupId,
      createdAt: DateTime.now(),
    );

    // Update the case to belong to the new group and update its hospital
    final updatedCase = surgicalCase.copyWith(
      groupId: newGroupId,
      hospital: hospital,
      startTime: startTime,
      orderIndex: 0,
    );

    state = state.copyWith(
      groups: [...state.groups, newGroup],
      cases: state.cases.map((c) => c.id == caseId ? updatedCase : c).toList(),
    );

    print('🟢 [WaitingRoom] Detached case to new group: $newGroupId');
  }

  /// Reattach a case back to its original group.
  void reattachCase(String caseId) {
    final surgicalCase = state.cases.firstWhere((c) => c.id == caseId);
    final currentGroupId = surgicalCase.groupId;

    // Find max order index in the original group
    final originalGroupCases = state.cases
        .where((c) => c.groupId == surgicalCase.originalGroupId)
        .toList();
    final maxOrder = originalGroupCases.isEmpty
        ? 0
        : originalGroupCases
            .map((c) => c.orderIndex)
            .reduce((a, b) => a > b ? a : b);

    // Move case back to original group
    final updatedCase = surgicalCase.copyWith(
      groupId: surgicalCase.originalGroupId,
      orderIndex: maxOrder + 1,
    );

    // Remove the now-empty detached group
    final remainingCasesInCurrentGroup =
        state.cases.where((c) => c.groupId == currentGroupId && c.id != caseId);

    List<SurgeonGroup> updatedGroups = state.groups;
    if (remainingCasesInCurrentGroup.isEmpty) {
      updatedGroups =
          state.groups.where((g) => g.id != currentGroupId).toList();
    }

    state = state.copyWith(
      groups: updatedGroups,
      cases: state.cases.map((c) => c.id == caseId ? updatedCase : c).toList(),
    );

    print('🟢 [WaitingRoom] Reattached case to original group');
  }

  /// Update a surgeon group.
  void updateGroup(SurgeonGroup updatedGroup) {
    state = state.copyWith(
      groups:
          state.groups.map((g) => g.id == updatedGroup.id ? updatedGroup : g).toList(),
    );
  }

  /// Update a surgical case.
  void updateCase(SurgicalCase updatedCase) {
    state = state.copyWith(
      cases:
          state.cases.map((c) => c.id == updatedCase.id ? updatedCase : c).toList(),
    );
  }

  /// Delete a group and all its cases.
  void deleteGroup(String groupId) {
    state = state.copyWith(
      groups: state.groups.where((g) => g.id != groupId).toList(),
      cases: state.cases.where((c) => c.groupId != groupId).toList(),
    );
  }

  /// Delete a single case.
  void deleteCase(String caseId) {
    final surgicalCase = state.cases.firstWhere((c) => c.id == caseId);
    final groupId = surgicalCase.groupId;

    final updatedCases = state.cases.where((c) => c.id != caseId).toList();
    final remainingCasesInGroup =
        updatedCases.where((c) => c.groupId == groupId);

    // If group is empty and is a detached group, remove it
    List<SurgeonGroup> updatedGroups = state.groups;
    if (remainingCasesInGroup.isEmpty) {
      final group = state.groups.firstWhere((g) => g.id == groupId);
      if (group.isDetached) {
        updatedGroups = state.groups.where((g) => g.id != groupId).toList();
      }
    }

    state = state.copyWith(
      groups: updatedGroups,
      cases: updatedCases,
    );
  }

  /// Clear all data.
  void clearAll() {
    state = WaitingRoomState();
  }

  /// Clear any error.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Mark a group as exported to Daily Planner.
  void markAsExported(String groupId, String anaesthesiologistId) {
    state = state.copyWith(
      groups: state.groups.map((g) {
        if (g.id == groupId) {
          return g.copyWith(
            isExported: true,
            exportedToAnaesthesiologistId: anaesthesiologistId,
          );
        }
        return g;
      }).toList(),
    );
    print('🟢 [WaitingRoom] Marked group $groupId as exported');
  }

  /// Unmark a group as exported (return from Daily Planner).
  void unmarkAsExported(String groupId) {
    state = state.copyWith(
      groups: state.groups.map((g) {
        if (g.id == groupId) {
          return g.copyWith(
            isExported: false,
            exportedToAnaesthesiologistId: null,
          );
        }
        return g;
      }).toList(),
    );
    print('🟢 [WaitingRoom] Unmarked group $groupId as exported');
  }

  /// Sort all cases within a group by start time (earliest first).
  void sortGroupByTime(String groupId) {
    final groupCases = state.cases.where((c) => c.groupId == groupId).toList();
    
    if (groupCases.isEmpty) return;

    // Sort by start time
    groupCases.sort((a, b) => _compareStartTimes(a.startTime, b.startTime));

    // Update order indices
    final updatedCases = state.cases.map((c) {
      if (c.groupId == groupId) {
        final newIndex = groupCases.indexWhere((gc) => gc.id == c.id);
        return c.copyWith(orderIndex: newIndex);
      }
      return c;
    }).toList();

    // Also update the group's start time to the earliest case
    final earliestTime = groupCases.first.startTime;
    final updatedGroups = state.groups.map((g) {
      if (g.id == groupId && earliestTime != null) {
        return g.copyWith(startTime: earliestTime);
      }
      return g;
    }).toList();

    state = state.copyWith(
      cases: updatedCases,
      groups: updatedGroups,
    );

    print('🟢 [WaitingRoom] Sorted group $groupId by time');
  }

  /// Merge two cases into a new group.
  /// 
  /// The new group takes the hospital and surgeon from the TARGET case's group.
  /// Cases are automatically sorted by start time (earliest first).
  /// [draggedCaseId] - The case being dragged.
  /// [targetCaseId] - The case being dropped onto (provides hospital/surgeon).
  void mergeCases(String draggedCaseId, String targetCaseId) {
    // Don't merge a case with itself
    if (draggedCaseId == targetCaseId) return;

    final draggedCase = state.cases.firstWhere((c) => c.id == draggedCaseId);
    final targetCase = state.cases.firstWhere((c) => c.id == targetCaseId);

    // Don't merge if already in the same group
    if (draggedCase.groupId == targetCase.groupId) return;

    final targetGroup = state.groups.firstWhere(
      (g) => g.id == targetCase.groupId,
    );

    // Get the old group IDs for cleanup
    final draggedOldGroupId = draggedCase.groupId;
    final targetOldGroupId = targetCase.groupId;

    // Sort cases by start time to determine order
    final casesToMerge = [draggedCase, targetCase];
    casesToMerge.sort((a, b) => _compareStartTimes(a.startTime, b.startTime));

    // Get the earliest start time for the group
    final earliestStartTime = casesToMerge.first.startTime;

    // Create a new group with TARGET's hospital and surgeon info
    final newGroupId = _uuid.v4();
    final newGroup = SurgeonGroup(
      id: newGroupId,
      surgeonName: targetGroup.surgeonName,
      hospital: targetCase.hospital ?? targetGroup.hospital,
      startTime: earliestStartTime ?? targetGroup.startTime,
      sourceFileName: 'Merged group',
      isDetached: true,
      createdAt: DateTime.now(),
    );

    // Update both cases with order based on time sorting
    final updatedDraggedCase = draggedCase.copyWith(
      groupId: newGroupId,
      hospital: targetCase.hospital ?? targetGroup.hospital,
      orderIndex: casesToMerge.indexOf(draggedCase),
    );

    final updatedTargetCase = targetCase.copyWith(
      groupId: newGroupId,
      orderIndex: casesToMerge.indexOf(targetCase),
    );

    // Update cases in state
    var updatedCases = state.cases.map((c) {
      if (c.id == draggedCaseId) return updatedDraggedCase;
      if (c.id == targetCaseId) return updatedTargetCase;
      return c;
    }).toList();

    // Add the new group
    var updatedGroups = [...state.groups, newGroup];

    // Clean up empty groups (only detached ones)
    final draggedGroupRemaining = updatedCases.where(
      (c) => c.groupId == draggedOldGroupId,
    );
    final targetGroupRemaining = updatedCases.where(
      (c) => c.groupId == targetOldGroupId,
    );

    if (draggedGroupRemaining.isEmpty) {
      final oldGroup = state.groups.firstWhere((g) => g.id == draggedOldGroupId);
      if (oldGroup.isDetached) {
        updatedGroups = updatedGroups.where((g) => g.id != draggedOldGroupId).toList();
      }
    }

    if (targetGroupRemaining.isEmpty) {
      final oldGroup = state.groups.firstWhere((g) => g.id == targetOldGroupId);
      if (oldGroup.isDetached) {
        updatedGroups = updatedGroups.where((g) => g.id != targetOldGroupId).toList();
      }
    }

    state = state.copyWith(
      groups: updatedGroups,
      cases: updatedCases,
    );

    print('🟢 [WaitingRoom] Merged cases into new group: $newGroupId');
  }

  /// Compare two start time strings (HH:mm format).
  /// Returns negative if a < b, positive if a > b, zero if equal.
  /// Null times are sorted to the end.
  int _compareStartTimes(String? a, String? b) {
    if (a == null && b == null) return 0;
    if (a == null) return 1; // Null goes to end
    if (b == null) return -1;

    try {
      // Parse times in HH:mm or HH:mm:ss format
      final aParts = a.split(':').map(int.parse).toList();
      final bParts = b.split(':').map(int.parse).toList();

      final aMinutes = aParts[0] * 60 + (aParts.length > 1 ? aParts[1] : 0);
      final bMinutes = bParts[0] * 60 + (bParts.length > 1 ? bParts[1] : 0);

      return aMinutes.compareTo(bMinutes);
    } catch (e) {
      // If parsing fails, compare as strings
      return a.compareTo(b);
    }
  }
}

/// Provider for the waiting room state.
final waitingRoomProvider =
    NotifierProvider<WaitingRoomNotifier, WaitingRoomState>(
  WaitingRoomNotifier.new,
);
