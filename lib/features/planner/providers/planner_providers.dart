import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';

/// Provider for the list of time slots.
final timeSlotsProvider = Provider<List<String>>((ref) {
  final slots = <String>[];
  for (int hour = 7; hour <= 17; hour++) {
    slots.add('${hour.toString().padLeft(2, '0')}:00');
    slots.add('${hour.toString().padLeft(2, '0')}:30');
  }
  return slots;
});

/// Provider for the number of columns (doctors/staff).
final columnCountProvider = StateProvider<int>((ref) => 8);

/// Provider for column names.
final columnNamesProvider = StateProvider<List<String>>((ref) {
  return List.generate(8, (i) => 'Dr ${i + 1}');
});

/// State notifier for managing planner cases.
class PlannerCasesNotifier extends Notifier<List<PlannerCase>> {
  @override
  List<PlannerCase> build() => [];

  /// Adds a new case to the planner.
  void addCase(PlannerCase plannerCase) {
    state = [...state, plannerCase];
  }

  /// Updates an existing case.
  void updateCase(PlannerCase updatedCase) {
    state = state.map((c) {
      if (c.id == updatedCase.id) {
        return updatedCase;
      }
      return c;
    }).toList();
  }

  /// Moves a case to a new time slot and/or column.
  void moveCase(String caseId, String newTimeSlot, int newColumn) {
    state = state.map((c) {
      if (c.id == caseId) {
        return c.copyWith(timeSlot: newTimeSlot, column: newColumn);
      }
      return c;
    }).toList();
  }

  /// Removes a case from the planner.
  void removeCase(String caseId) {
    state = state.where((c) => c.id != caseId).toList();
  }

  /// Clears all cases.
  void clearAll() {
    state = [];
  }

  /// Creates a case from extracted document data.
  void addCaseFromExtraction({
    required String patientName,
    int? age,
    String? gender,
    String? phone,
    String? email,
    required String timeSlot,
    required int column,
    int durationMinutes = 30,
  }) {
    final newCase = PlannerCase(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: patientName,
      age: age ?? 0,
      gender: gender,
      phone: phone,
      email: email,
      timeSlot: timeSlot,
      column: column,
      durationMinutes: durationMinutes,
    );
    state = [...state, newCase];
  }
}

final plannerCasesProvider =
    NotifierProvider<PlannerCasesNotifier, List<PlannerCase>>(
  PlannerCasesNotifier.new,
);

/// Provider for the currently selected/editing case.
final selectedCaseProvider = StateProvider<PlannerCase?>((ref) => null);
