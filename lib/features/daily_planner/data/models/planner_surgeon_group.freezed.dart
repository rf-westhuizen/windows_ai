// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planner_surgeon_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlannerSurgeonGroup _$PlannerSurgeonGroupFromJson(Map<String, dynamic> json) {
  return _PlannerSurgeonGroup.fromJson(json);
}

/// @nodoc
mixin _$PlannerSurgeonGroup {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// ID of the assigned Anaesthesiologist
  String get anaesthesiologistId => throw _privateConstructorUsedError;

  /// Surgeon's name
  String? get surgeonName => throw _privateConstructorUsedError;

  /// Hospital name
  String? get hospital => throw _privateConstructorUsedError;

  /// Start time
  String? get startTime => throw _privateConstructorUsedError;

  /// Original source file name
  String? get sourceFileName => throw _privateConstructorUsedError;

  /// Timestamp when exported
  DateTime get exportedAt => throw _privateConstructorUsedError;

  /// Order index for sorting
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this PlannerSurgeonGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlannerSurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlannerSurgeonGroupCopyWith<PlannerSurgeonGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannerSurgeonGroupCopyWith<$Res> {
  factory $PlannerSurgeonGroupCopyWith(
    PlannerSurgeonGroup value,
    $Res Function(PlannerSurgeonGroup) then,
  ) = _$PlannerSurgeonGroupCopyWithImpl<$Res, PlannerSurgeonGroup>;
  @useResult
  $Res call({
    String id,
    String anaesthesiologistId,
    String? surgeonName,
    String? hospital,
    String? startTime,
    String? sourceFileName,
    DateTime exportedAt,
    int orderIndex,
  });
}

/// @nodoc
class _$PlannerSurgeonGroupCopyWithImpl<$Res, $Val extends PlannerSurgeonGroup>
    implements $PlannerSurgeonGroupCopyWith<$Res> {
  _$PlannerSurgeonGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlannerSurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? anaesthesiologistId = null,
    Object? surgeonName = freezed,
    Object? hospital = freezed,
    Object? startTime = freezed,
    Object? sourceFileName = freezed,
    Object? exportedAt = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            anaesthesiologistId: null == anaesthesiologistId
                ? _value.anaesthesiologistId
                : anaesthesiologistId // ignore: cast_nullable_to_non_nullable
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
            sourceFileName: freezed == sourceFileName
                ? _value.sourceFileName
                : sourceFileName // ignore: cast_nullable_to_non_nullable
                      as String?,
            exportedAt: null == exportedAt
                ? _value.exportedAt
                : exportedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            orderIndex: null == orderIndex
                ? _value.orderIndex
                : orderIndex // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlannerSurgeonGroupImplCopyWith<$Res>
    implements $PlannerSurgeonGroupCopyWith<$Res> {
  factory _$$PlannerSurgeonGroupImplCopyWith(
    _$PlannerSurgeonGroupImpl value,
    $Res Function(_$PlannerSurgeonGroupImpl) then,
  ) = __$$PlannerSurgeonGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String anaesthesiologistId,
    String? surgeonName,
    String? hospital,
    String? startTime,
    String? sourceFileName,
    DateTime exportedAt,
    int orderIndex,
  });
}

/// @nodoc
class __$$PlannerSurgeonGroupImplCopyWithImpl<$Res>
    extends _$PlannerSurgeonGroupCopyWithImpl<$Res, _$PlannerSurgeonGroupImpl>
    implements _$$PlannerSurgeonGroupImplCopyWith<$Res> {
  __$$PlannerSurgeonGroupImplCopyWithImpl(
    _$PlannerSurgeonGroupImpl _value,
    $Res Function(_$PlannerSurgeonGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlannerSurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? anaesthesiologistId = null,
    Object? surgeonName = freezed,
    Object? hospital = freezed,
    Object? startTime = freezed,
    Object? sourceFileName = freezed,
    Object? exportedAt = null,
    Object? orderIndex = null,
  }) {
    return _then(
      _$PlannerSurgeonGroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        anaesthesiologistId: null == anaesthesiologistId
            ? _value.anaesthesiologistId
            : anaesthesiologistId // ignore: cast_nullable_to_non_nullable
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
        sourceFileName: freezed == sourceFileName
            ? _value.sourceFileName
            : sourceFileName // ignore: cast_nullable_to_non_nullable
                  as String?,
        exportedAt: null == exportedAt
            ? _value.exportedAt
            : exportedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        orderIndex: null == orderIndex
            ? _value.orderIndex
            : orderIndex // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannerSurgeonGroupImpl implements _PlannerSurgeonGroup {
  const _$PlannerSurgeonGroupImpl({
    required this.id,
    required this.anaesthesiologistId,
    this.surgeonName,
    this.hospital,
    this.startTime,
    this.sourceFileName,
    required this.exportedAt,
    this.orderIndex = 0,
  });

  factory _$PlannerSurgeonGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannerSurgeonGroupImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// ID of the assigned Anaesthesiologist
  @override
  final String anaesthesiologistId;

  /// Surgeon's name
  @override
  final String? surgeonName;

  /// Hospital name
  @override
  final String? hospital;

  /// Start time
  @override
  final String? startTime;

  /// Original source file name
  @override
  final String? sourceFileName;

  /// Timestamp when exported
  @override
  final DateTime exportedAt;

  /// Order index for sorting
  @override
  @JsonKey()
  final int orderIndex;

  @override
  String toString() {
    return 'PlannerSurgeonGroup(id: $id, anaesthesiologistId: $anaesthesiologistId, surgeonName: $surgeonName, hospital: $hospital, startTime: $startTime, sourceFileName: $sourceFileName, exportedAt: $exportedAt, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannerSurgeonGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.anaesthesiologistId, anaesthesiologistId) ||
                other.anaesthesiologistId == anaesthesiologistId) &&
            (identical(other.surgeonName, surgeonName) ||
                other.surgeonName == surgeonName) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.sourceFileName, sourceFileName) ||
                other.sourceFileName == sourceFileName) &&
            (identical(other.exportedAt, exportedAt) ||
                other.exportedAt == exportedAt) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    anaesthesiologistId,
    surgeonName,
    hospital,
    startTime,
    sourceFileName,
    exportedAt,
    orderIndex,
  );

  /// Create a copy of PlannerSurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannerSurgeonGroupImplCopyWith<_$PlannerSurgeonGroupImpl> get copyWith =>
      __$$PlannerSurgeonGroupImplCopyWithImpl<_$PlannerSurgeonGroupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannerSurgeonGroupImplToJson(this);
  }
}

abstract class _PlannerSurgeonGroup implements PlannerSurgeonGroup {
  const factory _PlannerSurgeonGroup({
    required final String id,
    required final String anaesthesiologistId,
    final String? surgeonName,
    final String? hospital,
    final String? startTime,
    final String? sourceFileName,
    required final DateTime exportedAt,
    final int orderIndex,
  }) = _$PlannerSurgeonGroupImpl;

  factory _PlannerSurgeonGroup.fromJson(Map<String, dynamic> json) =
      _$PlannerSurgeonGroupImpl.fromJson;

  /// Unique identifier
  @override
  String get id;

  /// ID of the assigned Anaesthesiologist
  @override
  String get anaesthesiologistId;

  /// Surgeon's name
  @override
  String? get surgeonName;

  /// Hospital name
  @override
  String? get hospital;

  /// Start time
  @override
  String? get startTime;

  /// Original source file name
  @override
  String? get sourceFileName;

  /// Timestamp when exported
  @override
  DateTime get exportedAt;

  /// Order index for sorting
  @override
  int get orderIndex;

  /// Create a copy of PlannerSurgeonGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlannerSurgeonGroupImplCopyWith<_$PlannerSurgeonGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
