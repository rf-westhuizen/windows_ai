// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anaesthesiologist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Anaesthesiologist _$AnaesthesiologistFromJson(Map<String, dynamic> json) {
  return _Anaesthesiologist.fromJson(json);
}

/// @nodoc
mixin _$Anaesthesiologist {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Anaesthesiologist's name
  String get name => throw _privateConstructorUsedError;

  /// Whether this is a helper anaesthesiologist
  bool get isHelper => throw _privateConstructorUsedError;

  /// Timestamp when created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Anaesthesiologist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Anaesthesiologist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnaesthesiologistCopyWith<Anaesthesiologist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnaesthesiologistCopyWith<$Res> {
  factory $AnaesthesiologistCopyWith(
    Anaesthesiologist value,
    $Res Function(Anaesthesiologist) then,
  ) = _$AnaesthesiologistCopyWithImpl<$Res, Anaesthesiologist>;
  @useResult
  $Res call({String id, String name, bool isHelper, DateTime createdAt});
}

/// @nodoc
class _$AnaesthesiologistCopyWithImpl<$Res, $Val extends Anaesthesiologist>
    implements $AnaesthesiologistCopyWith<$Res> {
  _$AnaesthesiologistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Anaesthesiologist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isHelper = null,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            isHelper: null == isHelper
                ? _value.isHelper
                : isHelper // ignore: cast_nullable_to_non_nullable
                      as bool,
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
abstract class _$$AnaesthesiologistImplCopyWith<$Res>
    implements $AnaesthesiologistCopyWith<$Res> {
  factory _$$AnaesthesiologistImplCopyWith(
    _$AnaesthesiologistImpl value,
    $Res Function(_$AnaesthesiologistImpl) then,
  ) = __$$AnaesthesiologistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, bool isHelper, DateTime createdAt});
}

/// @nodoc
class __$$AnaesthesiologistImplCopyWithImpl<$Res>
    extends _$AnaesthesiologistCopyWithImpl<$Res, _$AnaesthesiologistImpl>
    implements _$$AnaesthesiologistImplCopyWith<$Res> {
  __$$AnaesthesiologistImplCopyWithImpl(
    _$AnaesthesiologistImpl _value,
    $Res Function(_$AnaesthesiologistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Anaesthesiologist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? isHelper = null,
    Object? createdAt = null,
  }) {
    return _then(
      _$AnaesthesiologistImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        isHelper: null == isHelper
            ? _value.isHelper
            : isHelper // ignore: cast_nullable_to_non_nullable
                  as bool,
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
class _$AnaesthesiologistImpl implements _Anaesthesiologist {
  const _$AnaesthesiologistImpl({
    required this.id,
    required this.name,
    this.isHelper = false,
    required this.createdAt,
  });

  factory _$AnaesthesiologistImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnaesthesiologistImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Anaesthesiologist's name
  @override
  final String name;

  /// Whether this is a helper anaesthesiologist
  @override
  @JsonKey()
  final bool isHelper;

  /// Timestamp when created
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'Anaesthesiologist(id: $id, name: $name, isHelper: $isHelper, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnaesthesiologistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isHelper, isHelper) ||
                other.isHelper == isHelper) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, isHelper, createdAt);

  /// Create a copy of Anaesthesiologist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnaesthesiologistImplCopyWith<_$AnaesthesiologistImpl> get copyWith =>
      __$$AnaesthesiologistImplCopyWithImpl<_$AnaesthesiologistImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AnaesthesiologistImplToJson(this);
  }
}

abstract class _Anaesthesiologist implements Anaesthesiologist {
  const factory _Anaesthesiologist({
    required final String id,
    required final String name,
    final bool isHelper,
    required final DateTime createdAt,
  }) = _$AnaesthesiologistImpl;

  factory _Anaesthesiologist.fromJson(Map<String, dynamic> json) =
      _$AnaesthesiologistImpl.fromJson;

  /// Unique identifier
  @override
  String get id;

  /// Anaesthesiologist's name
  @override
  String get name;

  /// Whether this is a helper anaesthesiologist
  @override
  bool get isHelper;

  /// Timestamp when created
  @override
  DateTime get createdAt;

  /// Create a copy of Anaesthesiologist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnaesthesiologistImplCopyWith<_$AnaesthesiologistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
