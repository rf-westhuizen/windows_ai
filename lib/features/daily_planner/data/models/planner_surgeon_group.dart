import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_surgeon_group.freezed.dart';
part 'planner_surgeon_group.g.dart';

/// Represents a Surgeon Group in the Daily Planner.
/// This is an exported group from the Waiting Room assigned to an Anaesthesiologist.
@freezed
class PlannerSurgeonGroup with _$PlannerSurgeonGroup {
  const factory PlannerSurgeonGroup({
    /// Unique identifier
    required String id,

    /// ID of the assigned Anaesthesiologist
    required String anaesthesiologistId,

    /// Surgeon's name
    String? surgeonName,

    /// Hospital name
    String? hospital,

    /// Start time
    String? startTime,

    /// Original source file name
    String? sourceFileName,

    /// Timestamp when exported
    required DateTime exportedAt,

    /// Order index for sorting
    @Default(0) int orderIndex,
  }) = _PlannerSurgeonGroup;

  factory PlannerSurgeonGroup.fromJson(Map<String, dynamic> json) =>
      _$PlannerSurgeonGroupFromJson(json);
}
