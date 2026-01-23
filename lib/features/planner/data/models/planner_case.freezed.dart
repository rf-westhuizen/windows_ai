// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'planner_case.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PlannerCase _$PlannerCaseFromJson(Map<String, dynamic> json) {
  return _PlannerCase.fromJson(json);
}

/// @nodoc
mixin _$PlannerCase {
  String get id => throw _privateConstructorUsedError;
  String get patientName => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  String? get operation => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String get timeSlot => throw _privateConstructorUsedError;
  int get column => throw _privateConstructorUsedError;
  int get durationMinutes => throw _privateConstructorUsedError;

  /// Serializes this PlannerCase to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlannerCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlannerCaseCopyWith<PlannerCase> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlannerCaseCopyWith<$Res> {
  factory $PlannerCaseCopyWith(
    PlannerCase value,
    $Res Function(PlannerCase) then,
  ) = _$PlannerCaseCopyWithImpl<$Res, PlannerCase>;
  @useResult
  $Res call({
    String id,
    String patientName,
    int age,
    String? gender,
    String? operation,
    String? phone,
    String? email,
    String timeSlot,
    int column,
    int durationMinutes,
  });
}

/// @nodoc
class _$PlannerCaseCopyWithImpl<$Res, $Val extends PlannerCase>
    implements $PlannerCaseCopyWith<$Res> {
  _$PlannerCaseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlannerCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientName = null,
    Object? age = null,
    Object? gender = freezed,
    Object? operation = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? timeSlot = null,
    Object? column = null,
    Object? durationMinutes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            patientName: null == patientName
                ? _value.patientName
                : patientName // ignore: cast_nullable_to_non_nullable
                      as String,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            operation: freezed == operation
                ? _value.operation
                : operation // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            email: freezed == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String?,
            timeSlot: null == timeSlot
                ? _value.timeSlot
                : timeSlot // ignore: cast_nullable_to_non_nullable
                      as String,
            column: null == column
                ? _value.column
                : column // ignore: cast_nullable_to_non_nullable
                      as int,
            durationMinutes: null == durationMinutes
                ? _value.durationMinutes
                : durationMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PlannerCaseImplCopyWith<$Res>
    implements $PlannerCaseCopyWith<$Res> {
  factory _$$PlannerCaseImplCopyWith(
    _$PlannerCaseImpl value,
    $Res Function(_$PlannerCaseImpl) then,
  ) = __$$PlannerCaseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String patientName,
    int age,
    String? gender,
    String? operation,
    String? phone,
    String? email,
    String timeSlot,
    int column,
    int durationMinutes,
  });
}

/// @nodoc
class __$$PlannerCaseImplCopyWithImpl<$Res>
    extends _$PlannerCaseCopyWithImpl<$Res, _$PlannerCaseImpl>
    implements _$$PlannerCaseImplCopyWith<$Res> {
  __$$PlannerCaseImplCopyWithImpl(
    _$PlannerCaseImpl _value,
    $Res Function(_$PlannerCaseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PlannerCase
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? patientName = null,
    Object? age = null,
    Object? gender = freezed,
    Object? operation = freezed,
    Object? phone = freezed,
    Object? email = freezed,
    Object? timeSlot = null,
    Object? column = null,
    Object? durationMinutes = null,
  }) {
    return _then(
      _$PlannerCaseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        patientName: null == patientName
            ? _value.patientName
            : patientName // ignore: cast_nullable_to_non_nullable
                  as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        operation: freezed == operation
            ? _value.operation
            : operation // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        email: freezed == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String?,
        timeSlot: null == timeSlot
            ? _value.timeSlot
            : timeSlot // ignore: cast_nullable_to_non_nullable
                  as String,
        column: null == column
            ? _value.column
            : column // ignore: cast_nullable_to_non_nullable
                  as int,
        durationMinutes: null == durationMinutes
            ? _value.durationMinutes
            : durationMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PlannerCaseImpl implements _PlannerCase {
  const _$PlannerCaseImpl({
    required this.id,
    required this.patientName,
    required this.age,
    this.gender,
    this.operation,
    this.phone,
    this.email,
    required this.timeSlot,
    required this.column,
    this.durationMinutes = 30,
  });

  factory _$PlannerCaseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlannerCaseImplFromJson(json);

  @override
  final String id;
  @override
  final String patientName;
  @override
  final int age;
  @override
  final String? gender;
  @override
  final String? operation;
  @override
  final String? phone;
  @override
  final String? email;
  @override
  final String timeSlot;
  @override
  final int column;
  @override
  @JsonKey()
  final int durationMinutes;

  @override
  String toString() {
    return 'PlannerCase(id: $id, patientName: $patientName, age: $age, gender: $gender, operation: $operation, phone: $phone, email: $email, timeSlot: $timeSlot, column: $column, durationMinutes: $durationMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlannerCaseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.patientName, patientName) ||
                other.patientName == patientName) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.operation, operation) ||
                other.operation == operation) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.timeSlot, timeSlot) ||
                other.timeSlot == timeSlot) &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.durationMinutes, durationMinutes) ||
                other.durationMinutes == durationMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    patientName,
    age,
    gender,
    operation,
    phone,
    email,
    timeSlot,
    column,
    durationMinutes,
  );

  /// Create a copy of PlannerCase
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlannerCaseImplCopyWith<_$PlannerCaseImpl> get copyWith =>
      __$$PlannerCaseImplCopyWithImpl<_$PlannerCaseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlannerCaseImplToJson(this);
  }
}

abstract class _PlannerCase implements PlannerCase {
  const factory _PlannerCase({
    required final String id,
    required final String patientName,
    required final int age,
    final String? gender,
    final String? operation,
    final String? phone,
    final String? email,
    required final String timeSlot,
    required final int column,
    final int durationMinutes,
  }) = _$PlannerCaseImpl;

  factory _PlannerCase.fromJson(Map<String, dynamic> json) =
      _$PlannerCaseImpl.fromJson;

  @override
  String get id;
  @override
  String get patientName;
  @override
  int get age;
  @override
  String? get gender;
  @override
  String? get operation;
  @override
  String? get phone;
  @override
  String? get email;
  @override
  String get timeSlot;
  @override
  int get column;
  @override
  int get durationMinutes;

  /// Create a copy of PlannerCase
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlannerCaseImplCopyWith<_$PlannerCaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
