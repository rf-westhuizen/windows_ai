// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extracted_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExtractedFieldImpl _$$ExtractedFieldImplFromJson(Map<String, dynamic> json) =>
    _$ExtractedFieldImpl(
      label: json['label'] as String,
      value: json['value'] as String,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$ExtractedFieldImplToJson(
  _$ExtractedFieldImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'value': instance.value,
  'confidence': instance.confidence,
};

_$ExtractedDocumentImpl _$$ExtractedDocumentImplFromJson(
  Map<String, dynamic> json,
) => _$ExtractedDocumentImpl(
  id: json['id'] as String,
  fileName: json['fileName'] as String,
  filePath: json['filePath'] as String,
  documentType: const DocumentTypeConverter().fromJson(
    json['documentType'] as String,
  ),
  fields: (json['fields'] as List<dynamic>)
      .map((e) => ExtractedField.fromJson(e as Map<String, dynamic>))
      .toList(),
  extractedAt: DateTime.parse(json['extractedAt'] as String),
  rawText: json['rawText'] as String?,
  status: json['status'] == null
      ? ExtractionStatus.pending
      : const ExtractionStatusConverter().fromJson(json['status'] as String),
  errorMessage: json['errorMessage'] as String?,
);

Map<String, dynamic> _$$ExtractedDocumentImplToJson(
  _$ExtractedDocumentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'filePath': instance.filePath,
  'documentType': const DocumentTypeConverter().toJson(instance.documentType),
  'fields': instance.fields,
  'extractedAt': instance.extractedAt.toIso8601String(),
  'rawText': instance.rawText,
  'status': const ExtractionStatusConverter().toJson(instance.status),
  'errorMessage': instance.errorMessage,
};
