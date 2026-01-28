// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'planner_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlannerCaseImpl _$$PlannerCaseImplFromJson(Map<String, dynamic> json) =>
    _$PlannerCaseImpl(
      id: json['id'] as String,
      surgeonGroupId: json['surgeonGroupId'] as String,
      patientName: json['patientName'] as String?,
      patientAge: json['patientAge'] as String?,
      operation: json['operation'] as String?,
      startTime: json['startTime'] as String?,
      durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
      medicalAid: json['medicalAid'] as String?,
      icd10Codes:
          (json['icd10Codes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      hospital: json['hospital'] as String?,
      notes: json['notes'] as String?,
      orderIndex: (json['orderIndex'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PlannerCaseImplToJson(_$PlannerCaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surgeonGroupId': instance.surgeonGroupId,
      'patientName': instance.patientName,
      'patientAge': instance.patientAge,
      'operation': instance.operation,
      'startTime': instance.startTime,
      'durationMinutes': instance.durationMinutes,
      'medicalAid': instance.medicalAid,
      'icd10Codes': instance.icd10Codes,
      'hospital': instance.hospital,
      'notes': instance.notes,
      'orderIndex': instance.orderIndex,
    };
