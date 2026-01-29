// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surgical_case.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurgicalCaseImpl _$$SurgicalCaseImplFromJson(Map<String, dynamic> json) =>
    _$SurgicalCaseImpl(
      id: json['id'] as String,
      groupId: json['groupId'] as String,
      originalGroupId: json['originalGroupId'] as String,
      patientName: json['patientName'] as String?,
      patientAge: json['patientAge'] as String?,
      patientGender: json['patientGender'] as String?,
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

Map<String, dynamic> _$$SurgicalCaseImplToJson(_$SurgicalCaseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'originalGroupId': instance.originalGroupId,
      'patientName': instance.patientName,
      'patientAge': instance.patientAge,
      'patientGender': instance.patientGender,
      'operation': instance.operation,
      'startTime': instance.startTime,
      'durationMinutes': instance.durationMinutes,
      'medicalAid': instance.medicalAid,
      'icd10Codes': instance.icd10Codes,
      'hospital': instance.hospital,
      'notes': instance.notes,
      'orderIndex': instance.orderIndex,
    };
