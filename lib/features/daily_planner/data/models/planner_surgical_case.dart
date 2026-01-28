import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_surgical_case.freezed.dart';
part 'planner_surgical_case.g.dart';

/// Represents a surgical case in the daily planner.
@freezed
class PlannerSurgicalCase with _$PlannerSurgicalCase {
  const factory PlannerSurgicalCase({
    /// Unique identifier
    required String id,

    /// Parent surgeon group ID
    required String surgeonGroupId,

    /// Patient's full name
    String? patientName,

    /// Patient's age or birth year
    String? patientAge,

    /// Operation/procedure to be performed
    String? operation,

    /// Scheduled start time
    String? startTime,

    /// Duration in minutes
    int? durationMinutes,

    /// Medical aid/insurance provider
    String? medicalAid,

    /// ICD-10 diagnosis codes
    @Default([]) List<String> icd10Codes,

    /// Hospital name
    String? hospital,

    /// Additional notes
    String? notes,

    /// Order index for sorting
    @Default(0) int orderIndex,
  }) = _PlannerSurgicalCase;

  factory PlannerSurgicalCase.fromJson(Map<String, dynamic> json) =>
      _$PlannerSurgicalCaseFromJson(json);
}
