// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drawer_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DrawerModel {
  UserData get user => throw _privateConstructorUsedError;
  List<ChatRoomData> get roomList => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DrawerModelCopyWith<DrawerModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DrawerModelCopyWith<$Res> {
  factory $DrawerModelCopyWith(
          DrawerModel value, $Res Function(DrawerModel) then) =
      _$DrawerModelCopyWithImpl<$Res, DrawerModel>;
  @useResult
  $Res call({UserData user, List<ChatRoomData> roomList});

  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class _$DrawerModelCopyWithImpl<$Res, $Val extends DrawerModel>
    implements $DrawerModelCopyWith<$Res> {
  _$DrawerModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? roomList = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
      roomList: null == roomList
          ? _value.roomList
          : roomList // ignore: cast_nullable_to_non_nullable
              as List<ChatRoomData>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserDataCopyWith<$Res> get user {
    return $UserDataCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DrawerModelImplCopyWith<$Res>
    implements $DrawerModelCopyWith<$Res> {
  factory _$$DrawerModelImplCopyWith(
          _$DrawerModelImpl value, $Res Function(_$DrawerModelImpl) then) =
      __$$DrawerModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UserData user, List<ChatRoomData> roomList});

  @override
  $UserDataCopyWith<$Res> get user;
}

/// @nodoc
class __$$DrawerModelImplCopyWithImpl<$Res>
    extends _$DrawerModelCopyWithImpl<$Res, _$DrawerModelImpl>
    implements _$$DrawerModelImplCopyWith<$Res> {
  __$$DrawerModelImplCopyWithImpl(
      _$DrawerModelImpl _value, $Res Function(_$DrawerModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? roomList = null,
  }) {
    return _then(_$DrawerModelImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserData,
      roomList: null == roomList
          ? _value._roomList
          : roomList // ignore: cast_nullable_to_non_nullable
              as List<ChatRoomData>,
    ));
  }
}

/// @nodoc

class _$DrawerModelImpl implements _DrawerModel {
  const _$DrawerModelImpl(
      {this.user = const UserData(name: 'guest'),
      final List<ChatRoomData> roomList = const []})
      : _roomList = roomList;

  @override
  @JsonKey()
  final UserData user;
  final List<ChatRoomData> _roomList;
  @override
  @JsonKey()
  List<ChatRoomData> get roomList {
    if (_roomList is EqualUnmodifiableListView) return _roomList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roomList);
  }

  @override
  String toString() {
    return 'DrawerModel(user: $user, roomList: $roomList)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DrawerModelImpl &&
            (identical(other.user, user) || other.user == user) &&
            const DeepCollectionEquality().equals(other._roomList, _roomList));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, user, const DeepCollectionEquality().hash(_roomList));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DrawerModelImplCopyWith<_$DrawerModelImpl> get copyWith =>
      __$$DrawerModelImplCopyWithImpl<_$DrawerModelImpl>(this, _$identity);
}

abstract class _DrawerModel implements DrawerModel {
  const factory _DrawerModel(
      {final UserData user,
      final List<ChatRoomData> roomList}) = _$DrawerModelImpl;

  @override
  UserData get user;
  @override
  List<ChatRoomData> get roomList;
  @override
  @JsonKey(ignore: true)
  _$$DrawerModelImplCopyWith<_$DrawerModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
