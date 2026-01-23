import 'package:freezed_annotation/freezed_annotation.dart';

part 'planner_case.freezed.dart';
part 'planner_case.g.dart';

/// Represents a surgical/anaesthesiology case in the daily planner.
@freezed
class PlannerCase with _$PlannerCase {
  const factory PlannerCase({
    required String id,
    required String patientName,
    required int age,
    required String surgeonName,
    required String anaesthetistName,
    required String ward,
    required String operation,
    required DateTime time,
    required int durationMinutes,
    required int doctorIndex, // 1-8 for Dr 1 through Dr 8
  }) = _PlannerCase;

  factory PlannerCase.fromJson(Map<String, dynamic> json) =>
      _$PlannerCaseFromJson(json);
}
