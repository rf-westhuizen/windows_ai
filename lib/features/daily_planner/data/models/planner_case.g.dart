// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannerCaseImpl _$$PlannerCaseImplFromJson(Map<String, dynamic> json) =>
    _$PlannerCaseImpl(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      age: (json['age'] as num).toInt(),
      surgeonName: json['surgeonName'] as String,
      anaesthetistName: json['anaesthetistName'] as String,
      ward: json['ward'] as String,
      operation: json['operation'] as String,
      time: DateTime.parse(json['time'] as String),
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      doctorIndex: (json['doctorIndex'] as num).toInt(),
    );

Map<String, dynamic> _$$PlannerCaseImplToJson(_$PlannerCaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientName': instance.patientName,
      'age': instance.age,
      'surgeonName': instance.surgeonName,
      'anaesthetistName': instance.anaesthetistName,
      'ward': instance.ward,
      'operation': instance.operation,
      'time': instance.time.toIso8601String(),
      'durationMinutes': instance.durationMinutes,
      'doctorIndex': instance.doctorIndex,
    };
