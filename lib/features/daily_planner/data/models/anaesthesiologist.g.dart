// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'anaesthesiologist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AnaesthesiologistImpl _$$AnaesthesiologistImplFromJson(
  Map<String, dynamic> json,
) => _$AnaesthesiologistImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  isHelper: json['isHelper'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$AnaesthesiologistImplToJson(
  _$AnaesthesiologistImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isHelper': instance.isHelper,
  'createdAt': instance.createdAt.toIso8601String(),
};
