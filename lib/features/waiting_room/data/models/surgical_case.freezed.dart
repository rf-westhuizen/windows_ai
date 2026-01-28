// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'surgical_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SurgicalCase _$SurgicalCaseFromJson(Map<String, dynamic> json) {
  return _SurgicalCase.fromJson(json);
}

/// @nodoc
mixin _$SurgicalCase {
  /// Unique identifier for this case
  String get id => throw _privateConstructorUsedError;

  /// Current parent group ID
  String get groupId => throw _privateConstructorUsedError;

  /// Original group ID (for reattachment capability)
  String get originalGroupId => throw _privateConstructorUsedError;

  /// Patient's full name
  String? get patientName => throw _privateConstructorUsedError;

  /// Patient's age or birth year (as string for flexibility)
  String? get patientAge => throw _privateConstructorUsedError;

  /// Operation/procedure to be performed
  String? get operation => throw _privateConstructorUsedError;

  /// Scheduled start time
  String? get startTime => throw _privateConstructorUsedError;

  /// Duration in minutes
  int? get durationMinutes => throw _privateConstructorUsedError;

  /// Medical aid/insurance provider
  String? get medicalAid => throw _privateConstructorUsedError;

  /// ICD-10 diagnosis codes
  List<String> get icd10Codes => throw _privateConstructorUsedError;

  /// Hospital name (can override group's hospital)
  String? get hospital => throw _privateConstructorUsedError;

  /// Additional notes
  String? get notes => throw _privateConstructorUsedError;

  /// Order index for sorting within a group
  int get orderIndex => throw _privateConstructorUsedError;

  /// Serializes this SurgicalCase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SurgicalCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SurgicalCaseCopyWith<SurgicalCase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SurgicalCaseCopyWith<$Res> {
  factory $SurgicalCaseCopyWith(
    SurgicalCase value,
    $Res Function(SurgicalCase) then,
  ) = _$SurgicalCaseCopyWithImpl<$Res, SurgicalCase>;
  @useResult
  $Res call({
    String id,
    String groupId,
    String originalGroupId,
    String? patientName,
    String? patientAge,
    String? operation,
    String? startTime,
    int? durationMinutes,
    String? medicalAid,
    List<String> icd10Codes,
    String? hospital,
    String? notes,
    int orderIndex,
  });
}

/// @nodoc
class _$SurgicalCaseCopyWithImpl<$Res, $Val extends SurgicalCase>
    implements $SurgicalCaseCopyWith<$Res> {
  _$SurgicalCaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SurgicalCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? originalGroupId = null,
    Object? patientName = freezed,
    Object? patientAge = freezed,
    Object? operation = freezed,
    Object? startTime = freezed,
    Object? durationMinutes = freezed,
    Object? medicalAid = freezed,
    Object? icd10Codes = null,
    Object? hospital = freezed,
    Object? notes = freezed,
    Object? orderIndex = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            groupId: null == groupId
                ? _value.groupId
                : groupId // ignore: cast_nullable_to_non_nullable
                      as String,
            originalGroupId: null == originalGroupId
                ? _value.originalGroupId
                : originalGroupId // ignore: cast_nullable_to_non_nullable
                      as String,
            patientName: freezed == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String?,
            patientAge: freezed == patientAge
                ? _value.patientAge
                : patientAge // ignore: cast_nullable_to_non_nullable
                      as String?,
            operation: freezed == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as String?,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            durationMinutes: freezed == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            medicalAid: freezed == medicalAid
                ? _value.medicalAid
                : medicalAid // ignore: cast_nullable_to_non_nullable
                      as String?,
            icd10Codes: null == icd10Codes
                ? _value.icd10Codes
                : icd10Codes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            hospital: freezed == hospital
                ? _value.hospital
                : hospital // ignore: cast_nullable_to_non_nullable
                      as String?,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$SurgicalCaseImplCopyWith<$Res>
    implements $SurgicalCaseCopyWith<$Res> {
  factory _$$SurgicalCaseImplCopyWith(
    _$SurgicalCaseImpl value,
    $Res Function(_$SurgicalCaseImpl) then,
  ) = __$$SurgicalCaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String groupId,
    String originalGroupId,
    String? patientName,
    String? patientAge,
    String? operation,
    String? startTime,
    int? durationMinutes,
    String? medicalAid,
    List<String> icd10Codes,
    String? hospital,
    String? notes,
    int orderIndex,
  });
}

/// @nodoc
class __$$SurgicalCaseImplCopyWithImpl<$Res>
    extends _$SurgicalCaseCopyWithImpl<$Res, _$SurgicalCaseImpl>
    implements _$$SurgicalCaseImplCopyWith<$Res> {
  __$$SurgicalCaseImplCopyWithImpl(
    _$SurgicalCaseImpl _value,
    $Res Function(_$SurgicalCaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SurgicalCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? groupId = null,
    Object? originalGroupId = null,
    Object? patientName = freezed,
    Object? patientAge = freezed,
    Object? operation = freezed,
    Object? startTime = freezed,
    Object? durationMinutes = freezed,
    Object? medicalAid = freezed,
    Object? icd10Codes = null,
    Object? hospital = freezed,
    Object? notes = freezed,
    Object? orderIndex = null,
  }) {
    return _then(
      _$SurgicalCaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        groupId: null == groupId
            ? _value.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        originalGroupId: null == originalGroupId
            ? _value.originalGroupId
            : originalGroupId // ignore: cast_nullable_to_non_nullable
                  as String,
        patientName: freezed == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String?,
        patientAge: freezed == patientAge
            ? _value.patientAge
            : patientAge // ignore: cast_nullable_to_non_nullable
                  as String?,
        operation: freezed == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String?,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        durationMinutes: freezed == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        medicalAid: freezed == medicalAid
            ? _value.medicalAid
            : medicalAid // ignore: cast_nullable_to_non_nullable
                  as String?,
        icd10Codes: null == icd10Codes
            ? _value._icd10Codes
            : icd10Codes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        hospital: freezed == hospital
            ? _value.hospital
            : hospital // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$SurgicalCaseImpl implements _SurgicalCase {
  const _$SurgicalCaseImpl({
    required this.id,
    required this.groupId,
    required this.originalGroupId,
    this.patientName,
    this.patientAge,
    this.operation,
    this.startTime,
    this.durationMinutes,
    this.medicalAid,
    final List<String> icd10Codes = const [],
    this.hospital,
    this.notes,
    this.orderIndex = 0,
  }) : _icd10Codes = icd10Codes;

  factory _$SurgicalCaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SurgicalCaseImplFromJson(json);

  /// Unique identifier for this case
  @override
  final String id;

  /// Current parent group ID
  @override
  final String groupId;

  /// Original group ID (for reattachment capability)
  @override
  final String originalGroupId;

  /// Patient's full name
  @override
  final String? patientName;

  /// Patient's age or birth year (as string for flexibility)
  @override
  final String? patientAge;

  /// Operation/procedure to be performed
  @override
  final String? operation;

  /// Scheduled start time
  @override
  final String? startTime;

  /// Duration in minutes
  @override
  final int? durationMinutes;

  /// Medical aid/insurance provider
  @override
  final String? medicalAid;

  /// ICD-10 diagnosis codes
  final List<String> _icd10Codes;

  /// ICD-10 diagnosis codes
  @override
  @JsonKey()
  List<String> get icd10Codes {
    if (_icd10Codes is EqualUnmodifiableListView) return _icd10Codes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_icd10Codes);
  }

  /// Hospital name (can override group's hospital)
  @override
  final String? hospital;

  /// Additional notes
  @override
  final String? notes;

  /// Order index for sorting within a group
  @override
  @JsonKey()
  final int orderIndex;

  @override
  String toString() {
    return 'SurgicalCase(id: $id, groupId: $groupId, originalGroupId: $originalGroupId, patientName: $patientName, patientAge: $patientAge, operation: $operation, startTime: $startTime, durationMinutes: $durationMinutes, medicalAid: $medicalAid, icd10Codes: $icd10Codes, hospital: $hospital, notes: $notes, orderIndex: $orderIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SurgicalCaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.originalGroupId, originalGroupId) ||
                other.originalGroupId == originalGroupId) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.patientAge, patientAge) ||
                other.patientAge == patientAge) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes) &&
            (identical(other.medicalAid, medicalAid) ||
                other.medicalAid == medicalAid) &&
            const DeepCollectionEquality().equals(
              other._icd10Codes,
              _icd10Codes,
            ) &&
            (identical(other.hospital, hospital) ||
                other.hospital == hospital) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    groupId,
    originalGroupId,
    patientName,
    patientAge,
    operation,
    startTime,
    durationMinutes,
    medicalAid,
    const DeepCollectionEquality().hash(_icd10Codes),
    hospital,
    notes,
    orderIndex,
  );

  /// Create a copy of SurgicalCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SurgicalCaseImplCopyWith<_$SurgicalCaseImpl> get copyWith =>
      __$$SurgicalCaseImplCopyWithImpl<_$SurgicalCaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SurgicalCaseImplToJson(this);
  }
}

abstract class _SurgicalCase implements SurgicalCase {
  const factory _SurgicalCase({
    required final String id,
    required final String groupId,
    required final String originalGroupId,
    final String? patientName,
    final String? patientAge,
    final String? operation,
    final String? startTime,
    final int? durationMinutes,
    final String? medicalAid,
    final List<String> icd10Codes,
    final String? hospital,
    final String? notes,
    final int orderIndex,
  }) = _$SurgicalCaseImpl;

  factory _SurgicalCase.fromJson(Map<String, dynamic> json) =
      _$SurgicalCaseImpl.fromJson;

  /// Unique identifier for this case
  @override
  String get id;

  /// Current parent group ID
  @override
  String get groupId;

  /// Original group ID (for reattachment capability)
  @override
  String get originalGroupId;

  /// Patient's full name
  @override
  String? get patientName;

  /// Patient's age or birth year (as string for flexibility)
  @override
  String? get patientAge;

  /// Operation/procedure to be performed
  @override
  String? get operation;

  /// Scheduled start time
  @override
  String? get startTime;

  /// Duration in minutes
  @override
  int? get durationMinutes;

  /// Medical aid/insurance provider
  @override
  String? get medicalAid;

  /// ICD-10 diagnosis codes
  @override
  List<String> get icd10Codes;

  /// Hospital name (can override group's hospital)
  @override
  String? get hospital;

  /// Additional notes
  @override
  String? get notes;

  /// Order index for sorting within a group
  @override
  int get orderIndex;

  /// Create a copy of SurgicalCase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SurgicalCaseImplCopyWith<_$SurgicalCaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
