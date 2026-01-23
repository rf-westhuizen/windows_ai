// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'extracted_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExtractedField _$ExtractedFieldFromJson(Map<String, dynamic> json) {
  return _ExtractedField.fromJson(json);
}

/// @nodoc
mixin _$ExtractedField {
  String get label => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;

  /// Serializes this ExtractedField to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedFieldCopyWith<ExtractedField> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedFieldCopyWith<$Res> {
  factory $ExtractedFieldCopyWith(
    ExtractedField value,
    $Res Function(ExtractedField) then,
  ) = _$ExtractedFieldCopyWithImpl<$Res, ExtractedField>;
  @useResult
  $Res call({String label, String value, double confidence});
}

/// @nodoc
class _$ExtractedFieldCopyWithImpl<$Res, $Val extends ExtractedField>
    implements $ExtractedFieldCopyWith<$Res> {
  _$ExtractedFieldCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? confidence = null,
  }) {
    return _then(
      _value.copyWith(
            label: null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                      as String,
            value: null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                      as String,
            confidence: null == confidence
                ? _value.confidence
                : confidence // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExtractedFieldImplCopyWith<$Res>
    implements $ExtractedFieldCopyWith<$Res> {
  factory _$$ExtractedFieldImplCopyWith(
    _$ExtractedFieldImpl value,
    $Res Function(_$ExtractedFieldImpl) then,
  ) = __$$ExtractedFieldImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String value, double confidence});
}

/// @nodoc
class __$$ExtractedFieldImplCopyWithImpl<$Res>
    extends _$ExtractedFieldCopyWithImpl<$Res, _$ExtractedFieldImpl>
    implements _$$ExtractedFieldImplCopyWith<$Res> {
  __$$ExtractedFieldImplCopyWithImpl(
    _$ExtractedFieldImpl _value,
    $Res Function(_$ExtractedFieldImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExtractedField
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? confidence = null,
  }) {
    return _then(
      _$ExtractedFieldImpl(
        label: null == label
            ? _value.label
            : label // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _value.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
        confidence: null == confidence
            ? _value.confidence
            : confidence // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedFieldImpl implements _ExtractedField {
  const _$ExtractedFieldImpl({
    required this.label,
    required this.value,
    this.confidence = 1.0,
  });

  factory _$ExtractedFieldImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedFieldImplFromJson(json);

  @override
  final String label;
  @override
  final String value;
  @override
  @JsonKey()
  final double confidence;

  @override
  String toString() {
    return 'ExtractedField(label: $label, value: $value, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedFieldImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, confidence);

  /// Create a copy of ExtractedField
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedFieldImplCopyWith<_$ExtractedFieldImpl> get copyWith =>
      __$$ExtractedFieldImplCopyWithImpl<_$ExtractedFieldImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedFieldImplToJson(this);
  }
}

abstract class _ExtractedField implements ExtractedField {
  const factory _ExtractedField({
    required final String label,
    required final String value,
    final double confidence,
  }) = _$ExtractedFieldImpl;

  factory _ExtractedField.fromJson(Map<String, dynamic> json) =
      _$ExtractedFieldImpl.fromJson;

  @override
  String get label;
  @override
  String get value;
  @override
  double get confidence;

  /// Create a copy of ExtractedField
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedFieldImplCopyWith<_$ExtractedFieldImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExtractedDocument _$ExtractedDocumentFromJson(Map<String, dynamic> json) {
  return _ExtractedDocument.fromJson(json);
}

/// @nodoc
mixin _$ExtractedDocument {
  String get id => throw _privateConstructorUsedError;
  String get fileName => throw _privateConstructorUsedError;
  String get filePath => throw _privateConstructorUsedError;
  @DocumentTypeConverter()
  DocumentType get documentType => throw _privateConstructorUsedError;
  List<ExtractedField> get fields => throw _privateConstructorUsedError;
  DateTime get extractedAt => throw _privateConstructorUsedError;
  String? get rawText => throw _privateConstructorUsedError;
  @ExtractionStatusConverter()
  ExtractionStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Serializes this ExtractedDocument to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExtractedDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExtractedDocumentCopyWith<ExtractedDocument> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExtractedDocumentCopyWith<$Res> {
  factory $ExtractedDocumentCopyWith(
    ExtractedDocument value,
    $Res Function(ExtractedDocument) then,
  ) = _$ExtractedDocumentCopyWithImpl<$Res, ExtractedDocument>;
  @useResult
  $Res call({
    String id,
    String fileName,
    String filePath,
    @DocumentTypeConverter() DocumentType documentType,
    List<ExtractedField> fields,
    DateTime extractedAt,
    String? rawText,
    @ExtractionStatusConverter() ExtractionStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class _$ExtractedDocumentCopyWithImpl<$Res, $Val extends ExtractedDocument>
    implements $ExtractedDocumentCopyWith<$Res> {
  _$ExtractedDocumentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExtractedDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? filePath = null,
    Object? documentType = null,
    Object? fields = null,
    Object? extractedAt = null,
    Object? rawText = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fileName: null == fileName
                ? _value.fileName
                : fileName // ignore: cast_nullable_to_non_nullable
                      as String,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            documentType: null == documentType
                ? _value.documentType
                : documentType // ignore: cast_nullable_to_non_nullable
                      as DocumentType,
            fields: null == fields
                ? _value.fields
                : fields // ignore: cast_nullable_to_non_nullable
                      as List<ExtractedField>,
            extractedAt: null == extractedAt
                ? _value.extractedAt
                : extractedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            rawText: freezed == rawText
                ? _value.rawText
                : rawText // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ExtractionStatus,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExtractedDocumentImplCopyWith<$Res>
    implements $ExtractedDocumentCopyWith<$Res> {
  factory _$$ExtractedDocumentImplCopyWith(
    _$ExtractedDocumentImpl value,
    $Res Function(_$ExtractedDocumentImpl) then,
  ) = __$$ExtractedDocumentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String fileName,
    String filePath,
    @DocumentTypeConverter() DocumentType documentType,
    List<ExtractedField> fields,
    DateTime extractedAt,
    String? rawText,
    @ExtractionStatusConverter() ExtractionStatus status,
    String? errorMessage,
  });
}

/// @nodoc
class __$$ExtractedDocumentImplCopyWithImpl<$Res>
    extends _$ExtractedDocumentCopyWithImpl<$Res, _$ExtractedDocumentImpl>
    implements _$$ExtractedDocumentImplCopyWith<$Res> {
  __$$ExtractedDocumentImplCopyWithImpl(
    _$ExtractedDocumentImpl _value,
    $Res Function(_$ExtractedDocumentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExtractedDocument
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fileName = null,
    Object? filePath = null,
    Object? documentType = null,
    Object? fields = null,
    Object? extractedAt = null,
    Object? rawText = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$ExtractedDocumentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fileName: null == fileName
            ? _value.fileName
            : fileName // ignore: cast_nullable_to_non_nullable
                  as String,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        documentType: null == documentType
            ? _value.documentType
            : documentType // ignore: cast_nullable_to_non_nullable
                  as DocumentType,
        fields: null == fields
            ? _value._fields
            : fields // ignore: cast_nullable_to_non_nullable
                  as List<ExtractedField>,
        extractedAt: null == extractedAt
            ? _value.extractedAt
            : extractedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        rawText: freezed == rawText
            ? _value.rawText
            : rawText // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ExtractionStatus,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExtractedDocumentImpl implements _ExtractedDocument {
  const _$ExtractedDocumentImpl({
    required this.id,
    required this.fileName,
    required this.filePath,
    @DocumentTypeConverter() required this.documentType,
    required final List<ExtractedField> fields,
    required this.extractedAt,
    this.rawText,
    @ExtractionStatusConverter() this.status = ExtractionStatus.pending,
    this.errorMessage,
  }) : _fields = fields;

  factory _$ExtractedDocumentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExtractedDocumentImplFromJson(json);

  @override
  final String id;
  @override
  final String fileName;
  @override
  final String filePath;
  @override
  @DocumentTypeConverter()
  final DocumentType documentType;
  final List<ExtractedField> _fields;
  @override
  List<ExtractedField> get fields {
    if (_fields is EqualUnmodifiableListView) return _fields;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_fields);
  }

  @override
  final DateTime extractedAt;
  @override
  final String? rawText;
  @override
  @JsonKey()
  @ExtractionStatusConverter()
  final ExtractionStatus status;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ExtractedDocument(id: $id, fileName: $fileName, filePath: $filePath, documentType: $documentType, fields: $fields, extractedAt: $extractedAt, rawText: $rawText, status: $status, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExtractedDocumentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fileName, fileName) ||
                other.fileName == fileName) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.documentType, documentType) ||
                other.documentType == documentType) &&
            const DeepCollectionEquality().equals(other._fields, _fields) &&
            (identical(other.extractedAt, extractedAt) ||
                other.extractedAt == extractedAt) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    fileName,
    filePath,
    documentType,
    const DeepCollectionEquality().hash(_fields),
    extractedAt,
    rawText,
    status,
    errorMessage,
  );

  /// Create a copy of ExtractedDocument
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExtractedDocumentImplCopyWith<_$ExtractedDocumentImpl> get copyWith =>
      __$$ExtractedDocumentImplCopyWithImpl<_$ExtractedDocumentImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExtractedDocumentImplToJson(this);
  }
}

abstract class _ExtractedDocument implements ExtractedDocument {
  const factory _ExtractedDocument({
    required final String id,
    required final String fileName,
    required final String filePath,
    @DocumentTypeConverter() required final DocumentType documentType,
    required final List<ExtractedField> fields,
    required final DateTime extractedAt,
    final String? rawText,
    @ExtractionStatusConverter() final ExtractionStatus status,
    final String? errorMessage,
  }) = _$ExtractedDocumentImpl;

  factory _ExtractedDocument.fromJson(Map<String, dynamic> json) =
      _$ExtractedDocumentImpl.fromJson;

  @override
  String get id;
  @override
  String get fileName;
  @override
  String get filePath;
  @override
  @DocumentTypeConverter()
  DocumentType get documentType;
  @override
  List<ExtractedField> get fields;
  @override
  DateTime get extractedAt;
  @override
  String? get rawText;
  @override
  @ExtractionStatusConverter()
  ExtractionStatus get status;
  @override
  String? get errorMessage;

  /// Create a copy of ExtractedDocument
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExtractedDocumentImplCopyWith<_$ExtractedDocumentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
