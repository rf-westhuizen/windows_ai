// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surgeon_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SurgeonGroupImpl _$$SurgeonGroupImplFromJson(Map<String, dynamic> json) =>
    _$SurgeonGroupImpl(
      id: json['id'] as String,
      surgeonName: json['surgeonName'] as String?,
      hospital: json['hospital'] as String?,
      startTime: json['startTime'] as String?,
      sourceFileName: json['sourceFileName'] as String,
      isDetached: json['isDetached'] as bool? ?? false,
      detachedFromGroupId: json['detachedFromGroupId'] as String?,
      isExported: json['isExported'] as bool? ?? false,
      exportedToAnaesthesiologistId:
          json['exportedToAnaesthesiologistId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$SurgeonGroupImplToJson(_$SurgeonGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'surgeonName': instance.surgeonName,
      'hospital': instance.hospital,
      'startTime': instance.startTime,
      'sourceFileName': instance.sourceFileName,
      'isDetached': instance.isDetached,
      'detachedFromGroupId': instance.detachedFromGroupId,
      'isExported': instance.isExported,
      'exportedToAnaesthesiologistId': instance.exportedToAnaesthesiologistId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
