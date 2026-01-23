import 'package:freezed_annotation/freezed_annotation.dart';

import 'document_enums.dart';

part 'extracted_data.freezed.dart';
part 'extracted_data.g.dart';

/// Represents a single extracted field from a document.
/// 
/// Each field contains a [label] (e.g., "Name", "Age") and its 
/// extracted [value] along with a [confidence] score from 0.0 to 1.0.
@freezed
class ExtractedField with _$ExtractedField {
  const factory ExtractedField({
    required String label,
    required String value,
    @Default(1.0) double confidence,
  }) = _ExtractedField;

  factory ExtractedField.fromJson(Map<String, dynamic> json) =>
      _$ExtractedFieldFromJson(json);
}

/// JSON converter for [DocumentType] enum.
class DocumentTypeConverter implements JsonConverter<DocumentType, String> {
  const DocumentTypeConverter();

  @override
  DocumentType fromJson(String json) =>
      DocumentType.values.firstWhere((e) => e.name == json);

  @override
  String toJson(DocumentType object) => object.name;
}

/// JSON converter for [ExtractionStatus] enum.
class ExtractionStatusConverter implements JsonConverter<ExtractionStatus, String> {
  const ExtractionStatusConverter();

  @override
  ExtractionStatus fromJson(String json) =>
      ExtractionStatus.values.firstWhere((e) => e.name == json);

  @override
  String toJson(ExtractionStatus object) => object.name;
}

/// Represents the complete extracted data from a document.
/// 
/// Contains the source [fileName], list of [fields] extracted,
/// and metadata about the extraction process.
@freezed
class ExtractedDocument with _$ExtractedDocument {
  const factory ExtractedDocument({
    required String id,
    required String fileName,
    required String filePath,
    @DocumentTypeConverter() required DocumentType documentType,
    required List<ExtractedField> fields,
    required DateTime extractedAt,
    String? rawText,
    @ExtractionStatusConverter() 
    @Default(ExtractionStatus.pending) ExtractionStatus status,
    String? errorMessage,
  }) = _ExtractedDocument;

  factory ExtractedDocument.fromJson(Map<String, dynamic> json) =>
      _$ExtractedDocumentFromJson(json);
}
