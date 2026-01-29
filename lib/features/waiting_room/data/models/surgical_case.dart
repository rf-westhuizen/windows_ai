import 'package:freezed_annotation/freezed_annotation.dart';

part 'surgical_case.freezed.dart';
part 'surgical_case.g.dart';

/// Represents a single surgical case (Sub-Tile) in the waiting room.
///
/// Each case belongs to a [SurgeonGroup] and can be detached/reattached.
@freezed
class SurgicalCase with _$SurgicalCase {
  const factory SurgicalCase({
    /// Unique identifier for this case
    required String id,

    /// Current parent group ID
    required String groupId,

    /// Original group ID (for reattachment capability)
    required String originalGroupId,

    /// Patient's full name
    String? patientName,

    /// Patient's age or birth year (as string for flexibility)
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
  }) = _SurgicalCase;

  factory SurgicalCase.fromJson(Map<String, dynamic> json) =>
      _$SurgicalCaseFromJson(json);
}
