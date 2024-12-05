// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RegisterModel {
  String? get nameErrorText => throw _privateConstructorUsedError;
  String? get emailErrorText => throw _privateConstructorUsedError;
  String? get pwdErrorText => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterModelCopyWith<RegisterModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterModelCopyWith<$Res> {
  factory $RegisterModelCopyWith(
          RegisterModel value, $Res Function(RegisterModel) then) =
      _$RegisterModelCopyWithImpl<$Res, RegisterModel>;
  @useResult
  $Res call(
      {String? nameErrorText, String? emailErrorText, String? pwdErrorText});
}

/// @nodoc
class _$RegisterModelCopyWithImpl<$Res, $Val extends RegisterModel>
    implements $RegisterModelCopyWith<$Res> {
  _$RegisterModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameErrorText = freezed,
    Object? emailErrorText = freezed,
    Object? pwdErrorText = freezed,
  }) {
    return _then(_value.copyWith(
      nameErrorText: freezed == nameErrorText
          ? _value.nameErrorText
          : nameErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$RegisterModelImplCopyWith<$Res>
    implements $RegisterModelCopyWith<$Res> {
  factory _$$RegisterModelImplCopyWith(
          _$RegisterModelImpl value, $Res Function(_$RegisterModelImpl) then) =
      __$$RegisterModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? nameErrorText, String? emailErrorText, String? pwdErrorText});
}

/// @nodoc
class __$$RegisterModelImplCopyWithImpl<$Res>
    extends _$RegisterModelCopyWithImpl<$Res, _$RegisterModelImpl>
    implements _$$RegisterModelImplCopyWith<$Res> {
  __$$RegisterModelImplCopyWithImpl(
      _$RegisterModelImpl _value, $Res Function(_$RegisterModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nameErrorText = freezed,
    Object? emailErrorText = freezed,
    Object? pwdErrorText = freezed,
  }) {
    return _then(_$RegisterModelImpl(
      nameErrorText: freezed == nameErrorText
          ? _value.nameErrorText
          : nameErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
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

class _$RegisterModelImpl implements _RegisterModel {
  const _$RegisterModelImpl(
      {this.nameErrorText = null,
      this.emailErrorText = null,
      this.pwdErrorText = null});

  @override
  @JsonKey()
  final String? nameErrorText;
  @override
  @JsonKey()
  final String? emailErrorText;
  @override
  @JsonKey()
  final String? pwdErrorText;

  @override
  String toString() {
    return 'RegisterModel(nameErrorText: $nameErrorText, emailErrorText: $emailErrorText, pwdErrorText: $pwdErrorText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterModelImpl &&
            (identical(other.nameErrorText, nameErrorText) ||
                other.nameErrorText == nameErrorText) &&
            (identical(other.emailErrorText, emailErrorText) ||
                other.emailErrorText == emailErrorText) &&
            (identical(other.pwdErrorText, pwdErrorText) ||
                other.pwdErrorText == pwdErrorText));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, nameErrorText, emailErrorText, pwdErrorText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterModelImplCopyWith<_$RegisterModelImpl> get copyWith =>
      __$$RegisterModelImplCopyWithImpl<_$RegisterModelImpl>(this, _$identity);
}

abstract class _RegisterModel implements RegisterModel {
  const factory _RegisterModel(
      {final String? nameErrorText,
      final String? emailErrorText,
      final String? pwdErrorText}) = _$RegisterModelImpl;

  @override
  String? get nameErrorText;
  @override
  String? get emailErrorText;
  @override
  String? get pwdErrorText;
  @override
  @JsonKey(ignore: true)
  _$$RegisterModelImplCopyWith<_$RegisterModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
