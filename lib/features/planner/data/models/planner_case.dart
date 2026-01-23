import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_case.freezed.dart';
part 'planner_case.g.dart';

/// Represents a case/appointment on the planner.
@freezed
class PlannerCase with _$PlannerCase {
  const factory PlannerCase({
    required String id,
    required String patientName,
    required int age,
    String? gender,
    String? operation,
    String? phone,
    String? email,
    required String timeSlot,
    required int column,
    @Default(30) int durationMinutes,
  }) = _PlannerCase;

  factory PlannerCase.fromJson(Map<String, dynamic> json) =>
      _$PlannerCaseFromJson(json);
}
