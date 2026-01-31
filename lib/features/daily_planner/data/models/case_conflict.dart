/// Represents a scheduling conflict between two cases.
class CaseConflict {
  const CaseConflict({
    required this.caseId,
    required this.conflictingCaseId,
    required this.overlapMinutes,
    required this.message,
  });

  /// The case that has the conflict
  final String caseId;

  /// The case it conflicts with
  final String conflictingCaseId;

  /// How many minutes they overlap
  final int overlapMinutes;

  /// Human-readable conflict description
  final String message;
}

/// Represents a time block for Gantt chart visualization.
class CaseTimeBlock {
  const CaseTimeBlock({
    required this.caseId,
    required this.patientName,
    required this.operation,
    required this.startMinutes,
    required this.durationMinutes,
    required this.hasConflict,
    this.surgeonName,
  });

  final String caseId;
  final String patientName;
  final String? operation;
  final int startMinutes; // Minutes from midnight (e.g., 08:00 = 480)
  final int durationMinutes;
  final bool hasConflict;
  final String? surgeonName;

  int get endMinutes => startMinutes + durationMinutes;

  String get startTimeFormatted {
    final hours = startMinutes ~/ 60;
    final mins = startMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }

  String get endTimeFormatted {
    final hours = endMinutes ~/ 60;
    final mins = endMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}
