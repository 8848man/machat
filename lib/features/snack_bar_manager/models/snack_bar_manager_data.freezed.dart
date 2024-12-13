// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snack_bar_manager_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SnackBarManagerData {
  String get text => throw _privateConstructorUsedError;
  bool get dialogCall => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SnackBarManagerDataCopyWith<SnackBarManagerData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnackBarManagerDataCopyWith<$Res> {
  factory $SnackBarManagerDataCopyWith(
          SnackBarManagerData value, $Res Function(SnackBarManagerData) then) =
      _$SnackBarManagerDataCopyWithImpl<$Res, SnackBarManagerData>;
  @useResult
  $Res call({String text, bool dialogCall});
}

/// @nodoc
class _$SnackBarManagerDataCopyWithImpl<$Res, $Val extends SnackBarManagerData>
    implements $SnackBarManagerDataCopyWith<$Res> {
  _$SnackBarManagerDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? dialogCall = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      dialogCall: null == dialogCall
          ? _value.dialogCall
          : dialogCall // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SnackBarManagerDataImplCopyWith<$Res>
    implements $SnackBarManagerDataCopyWith<$Res> {
  factory _$$SnackBarManagerDataImplCopyWith(_$SnackBarManagerDataImpl value,
          $Res Function(_$SnackBarManagerDataImpl) then) =
      __$$SnackBarManagerDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, bool dialogCall});
}

/// @nodoc
class __$$SnackBarManagerDataImplCopyWithImpl<$Res>
    extends _$SnackBarManagerDataCopyWithImpl<$Res, _$SnackBarManagerDataImpl>
    implements _$$SnackBarManagerDataImplCopyWith<$Res> {
  __$$SnackBarManagerDataImplCopyWithImpl(_$SnackBarManagerDataImpl _value,
      $Res Function(_$SnackBarManagerDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? dialogCall = null,
  }) {
    return _then(_$SnackBarManagerDataImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      dialogCall: null == dialogCall
          ? _value.dialogCall
          : dialogCall // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SnackBarManagerDataImpl implements _SnackBarManagerData {
  _$SnackBarManagerDataImpl(
      {this.text = 'init value', this.dialogCall = false});

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final bool dialogCall;

  @override
  String toString() {
    return 'SnackBarManagerData(text: $text, dialogCall: $dialogCall)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnackBarManagerDataImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.dialogCall, dialogCall) ||
                other.dialogCall == dialogCall));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text, dialogCall);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SnackBarManagerDataImplCopyWith<_$SnackBarManagerDataImpl> get copyWith =>
      __$$SnackBarManagerDataImplCopyWithImpl<_$SnackBarManagerDataImpl>(
          this, _$identity);
}

abstract class _SnackBarManagerData implements SnackBarManagerData {
  factory _SnackBarManagerData({final String text, final bool dialogCall}) =
      _$SnackBarManagerDataImpl;

  @override
  String get text;
  @override
  bool get dialogCall;
  @override
  @JsonKey(ignore: true)
  _$$SnackBarManagerDataImplCopyWith<_$SnackBarManagerDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
