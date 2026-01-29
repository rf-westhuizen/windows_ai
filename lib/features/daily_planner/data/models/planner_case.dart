import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_case.freezed.dart';
part 'planner_case.g.dart';

/// Represents a surgical case in the Daily Planner.
@freezed
class PlannerCase with _$PlannerCase {
  const factory PlannerCase({
    /// Unique identifier
    required String id,

    /// ID of the parent surgeon group
    required String surgeonGroupId,

    /// Patient's full name
    String? patientName,

    /// Patient's age or birth year
    String? patientAge,

    /// Patient's gender (M/F)
    String? patientGender,

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

    /// Hospital name (can override group's hospital)
    String? hospital,

    /// Additional notes
    String? notes,

    /// Order index for sorting within a group
    @Default(0) int orderIndex,
  }) = _PlannerCase;

  factory PlannerCase.fromJson(Map<String, dynamic> json) =>
      _$PlannerCaseFromJson(json);
}
