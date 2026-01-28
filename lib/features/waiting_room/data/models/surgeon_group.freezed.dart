// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surgeon_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SurgeonGroup _$SurgeonGroupFromJson(Map<String, dynamic> json) {
  return _SurgeonGroup.fromJson(json);
}

/// @nodoc
mixin _$SurgeonGroup {
  /// Unique identifier for this group
  String get id => throw _privateConstructorUsedError;

  /// Surgeon's full name
  String? get surgeonName => throw _privateConstructorUsedError;

  /// Hospital name
  String? get hospital => throw _privateConstructorUsedError;

  /// Initial start time for first case
  String? get startTime => throw _privateConstructorUsedError;

  /// Source file name (PDF/image that was processed)
  String get sourceFileName => throw _privateConstructorUsedError;

  /// Whether this group was created from a detached case
  bool get isDetached => throw _privateConstructorUsedError;

  /// Original group ID if this is a detached group
  String? get detachedFromGroupId => throw _privateConstructorUsedError;

  /// Whether this group has been exported to Daily Planner
  bool get isExported => throw _privateConstructorUsedError;

  /// ID of the anaesthesiologist it was exported to
  String? get exportedToAnaesthesiologistId =>
      throw _privateConstructorUsedError;

  /// Timestamp when this group was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this SurgeonGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurgeonGroupCopyWith<SurgeonGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurgeonGroupCopyWith<$Res> {
  factory $SurgeonGroupCopyWith(
    SurgeonGroup value,
    $Res Function(SurgeonGroup) then,
  ) = _$SurgeonGroupCopyWithImpl<$Res, SurgeonGroup>;
  @useResult
  $Res call({
    String id,
    String? surgeonName,
    String? hospital,
    String? startTime,
    String sourceFileName,
    bool isDetached,
    String? detachedFromGroupId,
    bool isExported,
    String? exportedToAnaesthesiologistId,
    DateTime createdAt,
  });
}

/// @nodoc
class _$SurgeonGroupCopyWithImpl<$Res, $Val extends SurgeonGroup>
    implements $SurgeonGroupCopyWith<$Res> {
  _$SurgeonGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surgeonName = freezed,
    Object? hospital = freezed,
    Object? startTime = freezed,
    Object? sourceFileName = null,
    Object? isDetached = null,
    Object? detachedFromGroupId = freezed,
    Object? isExported = null,
    Object? exportedToAnaesthesiologistId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            surgeonName: freezed == surgeonName
                ? _value.surgeonName
                : surgeonName // ignore: cast_nullable_to_non_nullable
                      as String?,
            hospital: freezed == hospital
                ? _value.hospital
                : hospital // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            sourceFileName: null == sourceFileName
                ? _value.sourceFileName
                : sourceFileName // ignore: cast_nullable_to_non_nullable
                      as String,
            isDetached: null == isDetached
                ? _value.isDetached
                : isDetached // ignore: cast_nullable_to_non_nullable
                      as bool,
            detachedFromGroupId: freezed == detachedFromGroupId
                ? _value.detachedFromGroupId
                : detachedFromGroupId // ignore: cast_nullable_to_non_nullable
                      as String?,
            isExported: null == isExported
                ? _value.isExported
                : isExported // ignore: cast_nullable_to_non_nullable
                      as bool,
            exportedToAnaesthesiologistId:
                freezed == exportedToAnaesthesiologistId
                ? _value.exportedToAnaesthesiologistId
                : exportedToAnaesthesiologistId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SurgeonGroupImplCopyWith<$Res>
    implements $SurgeonGroupCopyWith<$Res> {
  factory _$$SurgeonGroupImplCopyWith(
    _$SurgeonGroupImpl value,
    $Res Function(_$SurgeonGroupImpl) then,
  ) = __$$SurgeonGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String? surgeonName,
    String? hospital,
    String? startTime,
    String sourceFileName,
    bool isDetached,
    String? detachedFromGroupId,
    bool isExported,
    String? exportedToAnaesthesiologistId,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$SurgeonGroupImplCopyWithImpl<$Res>
    extends _$SurgeonGroupCopyWithImpl<$Res, _$SurgeonGroupImpl>
    implements _$$SurgeonGroupImplCopyWith<$Res> {
  __$$SurgeonGroupImplCopyWithImpl(
    _$SurgeonGroupImpl _value,
    $Res Function(_$SurgeonGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? surgeonName = freezed,
    Object? hospital = freezed,
    Object? startTime = freezed,
    Object? sourceFileName = null,
    Object? isDetached = null,
    Object? detachedFromGroupId = freezed,
    Object? isExported = null,
    Object? exportedToAnaesthesiologistId = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$SurgeonGroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        surgeonName: freezed == surgeonName
            ? _value.surgeonName
            : surgeonName // ignore: cast_nullable_to_non_nullable
                  as String?,
        hospital: freezed == hospital
            ? _value.hospital
            : hospital // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        sourceFileName: null == sourceFileName
            ? _value.sourceFileName
            : sourceFileName // ignore: cast_nullable_to_non_nullable
                  as String,
        isDetached: null == isDetached
            ? _value.isDetached
            : isDetached // ignore: cast_nullable_to_non_nullable
                  as bool,
        detachedFromGroupId: freezed == detachedFromGroupId
            ? _value.detachedFromGroupId
            : detachedFromGroupId // ignore: cast_nullable_to_non_nullable
                  as String?,
        isExported: null == isExported
            ? _value.isExported
            : isExported // ignore: cast_nullable_to_non_nullable
                  as bool,
        exportedToAnaesthesiologistId: freezed == exportedToAnaesthesiologistId
            ? _value.exportedToAnaesthesiologistId
            : exportedToAnaesthesiologistId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SurgeonGroupImpl implements _SurgeonGroup {
  const _$SurgeonGroupImpl({
    required this.id,
    this.surgeonName,
    this.hospital,
    this.startTime,
    required this.sourceFileName,
    this.isDetached = false,
    this.detachedFromGroupId,
    this.isExported = false,
    this.exportedToAnaesthesiologistId,
    required this.createdAt,
  });

  factory _$SurgeonGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurgeonGroupImplFromJson(json);

  /// Unique identifier for this group
  @override
  final String id;

  /// Surgeon's full name
  @override
  final String? surgeonName;

  /// Hospital name
  @override
  final String? hospital;

  /// Initial start time for first case
  @override
  final String? startTime;

  /// Source file name (PDF/image that was processed)
  @override
  final String sourceFileName;

  /// Whether this group was created from a detached case
  @override
  @JsonKey()
  final bool isDetached;

  /// Original group ID if this is a detached group
  @override
  final String? detachedFromGroupId;

  /// Whether this group has been exported to Daily Planner
  @override
  @JsonKey()
  final bool isExported;

  /// ID of the anaesthesiologist it was exported to
  @override
  final String? exportedToAnaesthesiologistId;

  /// Timestamp when this group was created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'SurgeonGroup(id: $id, surgeonName: $surgeonName, hospital: $hospital, startTime: $startTime, sourceFileName: $sourceFileName, isDetached: $isDetached, detachedFromGroupId: $detachedFromGroupId, isExported: $isExported, exportedToAnaesthesiologistId: $exportedToAnaesthesiologistId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurgeonGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.surgeonName, surgeonName) ||
                other.surgeonName == surgeonName) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.sourceFileName, sourceFileName) ||
                other.sourceFileName == sourceFileName) &&
            (identical(other.isDetached, isDetached) ||
                other.isDetached == isDetached) &&
            (identical(other.detachedFromGroupId, detachedFromGroupId) ||
                other.detachedFromGroupId == detachedFromGroupId) &&
            (identical(other.isExported, isExported) ||
                other.isExported == isExported) &&
            (identical(
                  other.exportedToAnaesthesiologistId,
                  exportedToAnaesthesiologistId,
                ) ||
                other.exportedToAnaesthesiologistId ==
                    exportedToAnaesthesiologistId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    surgeonName,
    hospital,
    startTime,
    sourceFileName,
    isDetached,
    detachedFromGroupId,
    isExported,
    exportedToAnaesthesiologistId,
    createdAt,
  );

  /// Create a copy of SurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurgeonGroupImplCopyWith<_$SurgeonGroupImpl> get copyWith =>
      __$$SurgeonGroupImplCopyWithImpl<_$SurgeonGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurgeonGroupImplToJson(this);
  }
}

abstract class _SurgeonGroup implements SurgeonGroup {
  const factory _SurgeonGroup({
    required final String id,
    final String? surgeonName,
    final String? hospital,
    final String? startTime,
    required final String sourceFileName,
    final bool isDetached,
    final String? detachedFromGroupId,
    final bool isExported,
    final String? exportedToAnaesthesiologistId,
    required final DateTime createdAt,
  }) = _$SurgeonGroupImpl;

  factory _SurgeonGroup.fromJson(Map<String, dynamic> json) =
      _$SurgeonGroupImpl.fromJson;

  /// Unique identifier for this group
  @override
  String get id;

  /// Surgeon's full name
  @override
  String? get surgeonName;

  /// Hospital name
  @override
  String? get hospital;

  /// Initial start time for first case
  @override
  String? get startTime;

  /// Source file name (PDF/image that was processed)
  @override
  String get sourceFileName;

  /// Whether this group was created from a detached case
  @override
  bool get isDetached;

  /// Original group ID if this is a detached group
  @override
  String? get detachedFromGroupId;

  /// Whether this group has been exported to Daily Planner
  @override
  bool get isExported;

  /// ID of the anaesthesiologist it was exported to
  @override
  String? get exportedToAnaesthesiologistId;

  /// Timestamp when this group was created
  @override
  DateTime get createdAt;

  /// Create a copy of SurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurgeonGroupImplCopyWith<_$SurgeonGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
