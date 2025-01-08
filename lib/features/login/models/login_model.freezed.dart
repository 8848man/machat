// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$LoginModel {
  String? get emailErrorText => throw _privateConstructorUsedError;
  String? get pwdErrorText => throw _privateConstructorUsedError;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginModelCopyWith<LoginModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginModelCopyWith<$Res> {
  factory $LoginModelCopyWith(
          LoginModel value, $Res Function(LoginModel) then) =
      _$LoginModelCopyWithImpl<$Res, LoginModel>;
  @useResult
  $Res call({String? emailErrorText, String? pwdErrorText});
}

/// @nodoc
class _$LoginModelCopyWithImpl<$Res, $Val extends LoginModel>
    implements $LoginModelCopyWith<$Res> {
  _$LoginModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailErrorText = freezed,
    Object? pwdErrorText = freezed,
  }) {
    return _then(_value.copyWith(
      emailErrorText: freezed == emailErrorText
          ? _value.emailErrorText
          : emailErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
      pwdErrorText: freezed == pwdErrorText
          ? _value.pwdErrorText
          : pwdErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginModelImplCopyWith<$Res>
    implements $LoginModelCopyWith<$Res> {
  factory _$$LoginModelImplCopyWith(
          _$LoginModelImpl value, $Res Function(_$LoginModelImpl) then) =
      __$$LoginModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? emailErrorText, String? pwdErrorText});
}

/// @nodoc
class __$$LoginModelImplCopyWithImpl<$Res>
    extends _$LoginModelCopyWithImpl<$Res, _$LoginModelImpl>
    implements _$$LoginModelImplCopyWith<$Res> {
  __$$LoginModelImplCopyWithImpl(
      _$LoginModelImpl _value, $Res Function(_$LoginModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailErrorText = freezed,
    Object? pwdErrorText = freezed,
  }) {
    return _then(_$LoginModelImpl(
      emailErrorText: freezed == emailErrorText
          ? _value.emailErrorText
          : emailErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
      pwdErrorText: freezed == pwdErrorText
          ? _value.pwdErrorText
          : pwdErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$LoginModelImpl implements _LoginModel {
  const _$LoginModelImpl(
      {this.emailErrorText = null, this.pwdErrorText = null});

  @override
  @JsonKey()
  final String? emailErrorText;
  @override
  @JsonKey()
  final String? pwdErrorText;

  @override
  String toString() {
    return 'LoginModel(emailErrorText: $emailErrorText, pwdErrorText: $pwdErrorText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginModelImpl &&
            (identical(other.emailErrorText, emailErrorText) ||
                other.emailErrorText == emailErrorText) &&
            (identical(other.pwdErrorText, pwdErrorText) ||
                other.pwdErrorText == pwdErrorText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emailErrorText, pwdErrorText);

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      __$$LoginModelImplCopyWithImpl<_$LoginModelImpl>(this, _$identity);
}

abstract class _LoginModel implements LoginModel {
  const factory _LoginModel(
      {final String? emailErrorText,
      final String? pwdErrorText}) = _$LoginModelImpl;

  @override
  String? get emailErrorText;
  @override
  String? get pwdErrorText;

  /// Create a copy of LoginModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginModelImplCopyWith<_$LoginModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
