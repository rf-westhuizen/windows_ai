import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/planner_case.dart';

/// State notifier for managing the daily planner cases.
class PlannerCasesNotifier extends Notifier<List<PlannerCase>> {
  @override
  List<PlannerCase> build() => [];

  /// Adds a new case to the planner.
  void addCase(PlannerCase newCase) {
    state = [...state, newCase];
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

  /// Moves a case to a new time slot and/or doctor.
  void moveCase(String caseId, DateTime newTime, int newDoctorIndex) {
    state = state.map((c) {
      if (c.id == caseId) {
        return c.copyWith(
          time: newTime,
          doctorIndex: newDoctorIndex,
        );
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
}

final plannerCasesProvider =
    NotifierProvider<PlannerCasesNotifier, List<PlannerCase>>(
  PlannerCasesNotifier.new,
);

/// Provider for the currently selected case being edited.
final selectedCaseProvider = StateProvider<PlannerCase?>((ref) => null);

/// Provider for the selected date.
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
