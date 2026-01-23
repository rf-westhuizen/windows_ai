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
      gender: json['gender'] as String?,
      operation: json['operation'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      timeSlot: json['timeSlot'] as String,
      column: (json['column'] as num).toInt(),
      durationMinutes: (json['durationMinutes'] as num?)?.toInt() ?? 30,
    );

Map<String, dynamic> _$$PlannerCaseImplToJson(_$PlannerCaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'patientName': instance.patientName,
      'age': instance.age,
      'gender': instance.gender,
      'operation': instance.operation,
      'phone': instance.phone,
      'email': instance.email,
      'timeSlot': instance.timeSlot,
      'column': instance.column,
      'durationMinutes': instance.durationMinutes,
    };
