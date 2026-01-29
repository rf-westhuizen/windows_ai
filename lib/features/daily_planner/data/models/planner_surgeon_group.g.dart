// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_surgeon_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannerSurgeonGroupImpl _$$PlannerSurgeonGroupImplFromJson(
  Map<String, dynamic> json,
) => _$PlannerSurgeonGroupImpl(
  id: json['id'] as String,
  anaesthesiologistId: json['anaesthesiologistId'] as String,
  surgeonName: json['surgeonName'] as String?,
  hospital: json['hospital'] as String?,
  startTime: json['startTime'] as String?,
  sourceFileName: json['sourceFileName'] as String?,
  exportedAt: DateTime.parse(json['exportedAt'] as String),
  orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
  waitingRoomGroupId: json['waitingRoomGroupId'] as String?,
);

Map<String, dynamic> _$$PlannerSurgeonGroupImplToJson(
  _$PlannerSurgeonGroupImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'anaesthesiologistId': instance.anaesthesiologistId,
  'surgeonName': instance.surgeonName,
  'hospital': instance.hospital,
  'startTime': instance.startTime,
  'sourceFileName': instance.sourceFileName,
  'exportedAt': instance.exportedAt.toIso8601String(),
  'orderIndex': instance.orderIndex,
  'waitingRoomGroupId': instance.waitingRoomGroupId,
};
