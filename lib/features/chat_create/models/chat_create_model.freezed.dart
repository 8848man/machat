// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_create_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatCreateModel {
  String? get roomNameErrorText => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatCreateModelCopyWith<ChatCreateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCreateModelCopyWith<$Res> {
  factory $ChatCreateModelCopyWith(
          ChatCreateModel value, $Res Function(ChatCreateModel) then) =
      _$ChatCreateModelCopyWithImpl<$Res, ChatCreateModel>;
  @useResult
  $Res call({String? roomNameErrorText});
}

/// @nodoc
class _$ChatCreateModelCopyWithImpl<$Res, $Val extends ChatCreateModel>
    implements $ChatCreateModelCopyWith<$Res> {
  _$ChatCreateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomNameErrorText = freezed,
  }) {
    return _then(_value.copyWith(
      roomNameErrorText: freezed == roomNameErrorText
          ? _value.roomNameErrorText
          : roomNameErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatCreateModelImplCopyWith<$Res>
    implements $ChatCreateModelCopyWith<$Res> {
  factory _$$ChatCreateModelImplCopyWith(_$ChatCreateModelImpl value,
          $Res Function(_$ChatCreateModelImpl) then) =
      __$$ChatCreateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? roomNameErrorText});
}

/// @nodoc
class __$$ChatCreateModelImplCopyWithImpl<$Res>
    extends _$ChatCreateModelCopyWithImpl<$Res, _$ChatCreateModelImpl>
    implements _$$ChatCreateModelImplCopyWith<$Res> {
  __$$ChatCreateModelImplCopyWithImpl(
      _$ChatCreateModelImpl _value, $Res Function(_$ChatCreateModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomNameErrorText = freezed,
  }) {
    return _then(_$ChatCreateModelImpl(
      roomNameErrorText: freezed == roomNameErrorText
          ? _value.roomNameErrorText
          : roomNameErrorText // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChatCreateModelImpl implements _ChatCreateModel {
  const _$ChatCreateModelImpl({this.roomNameErrorText = null});

  @override
  @JsonKey()
  final String? roomNameErrorText;

  @override
  String toString() {
    return 'ChatCreateModel(roomNameErrorText: $roomNameErrorText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatCreateModelImpl &&
            (identical(other.roomNameErrorText, roomNameErrorText) ||
                other.roomNameErrorText == roomNameErrorText));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roomNameErrorText);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatCreateModelImplCopyWith<_$ChatCreateModelImpl> get copyWith =>
      __$$ChatCreateModelImplCopyWithImpl<_$ChatCreateModelImpl>(
          this, _$identity);
}

abstract class _ChatCreateModel implements ChatCreateModel {
  const factory _ChatCreateModel({final String? roomNameErrorText}) =
      _$ChatCreateModelImpl;

  @override
  String? get roomNameErrorText;
  @override
  @JsonKey(ignore: true)
  _$$ChatCreateModelImplCopyWith<_$ChatCreateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
