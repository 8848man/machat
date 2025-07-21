// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return _UserData.fromJson(json);
}

/// @nodoc
mixin _$UserData {
  String get name => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profileUrl => throw _privateConstructorUsedError;
  String? get nationId => throw _privateConstructorUsedError;
  String? get role => throw _privateConstructorUsedError;

  /// Serializes this UserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserDataCopyWith<UserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserDataCopyWith<$Res> {
  factory $UserDataCopyWith(UserData value, $Res Function(UserData) then) =
      _$UserDataCopyWithImpl<$Res, UserData>;
  @useResult
  $Res call(
      {String name,
      String? id,
      String? email,
      String? profileUrl,
      String? nationId,
      String? role});
}

/// @nodoc
class _$UserDataCopyWithImpl<$Res, $Val extends UserData>
    implements $UserDataCopyWith<$Res> {
  _$UserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? email = freezed,
    Object? profileUrl = freezed,
    Object? nationId = freezed,
    Object? role = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nationId: freezed == nationId
          ? _value.nationId
          : nationId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserDataImplCopyWith<$Res>
    implements $UserDataCopyWith<$Res> {
  factory _$$UserDataImplCopyWith(
          _$UserDataImpl value, $Res Function(_$UserDataImpl) then) =
      __$$UserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? id,
      String? email,
      String? profileUrl,
      String? nationId,
      String? role});
}

/// @nodoc
class __$$UserDataImplCopyWithImpl<$Res>
    extends _$UserDataCopyWithImpl<$Res, _$UserDataImpl>
    implements _$$UserDataImplCopyWith<$Res> {
  __$$UserDataImplCopyWithImpl(
      _$UserDataImpl _value, $Res Function(_$UserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? email = freezed,
    Object? profileUrl = freezed,
    Object? nationId = freezed,
    Object? role = freezed,
  }) {
    return _then(_$UserDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nationId: freezed == nationId
          ? _value.nationId
          : nationId // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserDataImpl implements _UserData {
  const _$UserDataImpl(
      {required this.name,
      this.id,
      this.email,
      this.profileUrl,
      this.nationId,
      this.role});

  factory _$UserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserDataImplFromJson(json);

  @override
  final String name;
  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? profileUrl;
  @override
  final String? nationId;
  @override
  final String? role;

  @override
  String toString() {
    return 'UserData(name: $name, id: $id, email: $email, profileUrl: $profileUrl, nationId: $nationId, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(other.nationId, nationId) ||
                other.nationId == nationId) &&
            (identical(other.role, role) || other.role == role));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, id, email, profileUrl, nationId, role);

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      __$$UserDataImplCopyWithImpl<_$UserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserDataImplToJson(
      this,
    );
  }
}

abstract class _UserData implements UserData {
  const factory _UserData(
      {required final String name,
      final String? id,
      final String? email,
      final String? profileUrl,
      final String? nationId,
      final String? role}) = _$UserDataImpl;

  factory _UserData.fromJson(Map<String, dynamic> json) =
      _$UserDataImpl.fromJson;

  @override
  String get name;
  @override
  String? get id;
  @override
  String? get email;
  @override
  String? get profileUrl;
  @override
  String? get nationId;
  @override
  String? get role;

  /// Create a copy of UserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserDataImplCopyWith<_$UserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

RoomUserData _$RoomUserDataFromJson(Map<String, dynamic> json) {
  return _RoomUserData.fromJson(json);
}

/// @nodoc
mixin _$RoomUserData {
  String get name => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get profileUrl => throw _privateConstructorUsedError;
  String? get nationId => throw _privateConstructorUsedError;
  String? get lastJoinedAt => throw _privateConstructorUsedError;

  /// Serializes this RoomUserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RoomUserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RoomUserDataCopyWith<RoomUserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomUserDataCopyWith<$Res> {
  factory $RoomUserDataCopyWith(
          RoomUserData value, $Res Function(RoomUserData) then) =
      _$RoomUserDataCopyWithImpl<$Res, RoomUserData>;
  @useResult
  $Res call(
      {String name,
      String? id,
      String? email,
      String? profileUrl,
      String? nationId,
      String? lastJoinedAt});
}

/// @nodoc
class _$RoomUserDataCopyWithImpl<$Res, $Val extends RoomUserData>
    implements $RoomUserDataCopyWith<$Res> {
  _$RoomUserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RoomUserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? email = freezed,
    Object? profileUrl = freezed,
    Object? nationId = freezed,
    Object? lastJoinedAt = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nationId: freezed == nationId
          ? _value.nationId
          : nationId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastJoinedAt: freezed == lastJoinedAt
          ? _value.lastJoinedAt
          : lastJoinedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoomUserDataImplCopyWith<$Res>
    implements $RoomUserDataCopyWith<$Res> {
  factory _$$RoomUserDataImplCopyWith(
          _$RoomUserDataImpl value, $Res Function(_$RoomUserDataImpl) then) =
      __$$RoomUserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String? id,
      String? email,
      String? profileUrl,
      String? nationId,
      String? lastJoinedAt});
}

/// @nodoc
class __$$RoomUserDataImplCopyWithImpl<$Res>
    extends _$RoomUserDataCopyWithImpl<$Res, _$RoomUserDataImpl>
    implements _$$RoomUserDataImplCopyWith<$Res> {
  __$$RoomUserDataImplCopyWithImpl(
      _$RoomUserDataImpl _value, $Res Function(_$RoomUserDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RoomUserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = freezed,
    Object? email = freezed,
    Object? profileUrl = freezed,
    Object? nationId = freezed,
    Object? lastJoinedAt = freezed,
  }) {
    return _then(_$RoomUserDataImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      profileUrl: freezed == profileUrl
          ? _value.profileUrl
          : profileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      nationId: freezed == nationId
          ? _value.nationId
          : nationId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastJoinedAt: freezed == lastJoinedAt
          ? _value.lastJoinedAt
          : lastJoinedAt // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoomUserDataImpl implements _RoomUserData {
  const _$RoomUserDataImpl(
      {required this.name,
      this.id,
      this.email,
      this.profileUrl,
      this.nationId,
      this.lastJoinedAt});

  factory _$RoomUserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RoomUserDataImplFromJson(json);

  @override
  final String name;
  @override
  final String? id;
  @override
  final String? email;
  @override
  final String? profileUrl;
  @override
  final String? nationId;
  @override
  final String? lastJoinedAt;

  @override
  String toString() {
    return 'RoomUserData(name: $name, id: $id, email: $email, profileUrl: $profileUrl, nationId: $nationId, lastJoinedAt: $lastJoinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoomUserDataImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.profileUrl, profileUrl) ||
                other.profileUrl == profileUrl) &&
            (identical(other.nationId, nationId) ||
                other.nationId == nationId) &&
            (identical(other.lastJoinedAt, lastJoinedAt) ||
                other.lastJoinedAt == lastJoinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, id, email, profileUrl, nationId, lastJoinedAt);

  /// Create a copy of RoomUserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoomUserDataImplCopyWith<_$RoomUserDataImpl> get copyWith =>
      __$$RoomUserDataImplCopyWithImpl<_$RoomUserDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoomUserDataImplToJson(
      this,
    );
  }
}

abstract class _RoomUserData implements RoomUserData {
  const factory _RoomUserData(
      {required final String name,
      final String? id,
      final String? email,
      final String? profileUrl,
      final String? nationId,
      final String? lastJoinedAt}) = _$RoomUserDataImpl;

  factory _RoomUserData.fromJson(Map<String, dynamic> json) =
      _$RoomUserDataImpl.fromJson;

  @override
  String get name;
  @override
  String? get id;
  @override
  String? get email;
  @override
  String? get profileUrl;
  @override
  String? get nationId;
  @override
  String? get lastJoinedAt;

  /// Create a copy of RoomUserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoomUserDataImplCopyWith<_$RoomUserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$UserListModel {
  List<UserData> get friends => throw _privateConstructorUsedError;

  /// Create a copy of UserListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserListModelCopyWith<UserListModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListModelCopyWith<$Res> {
  factory $UserListModelCopyWith(
          UserListModel value, $Res Function(UserListModel) then) =
      _$UserListModelCopyWithImpl<$Res, UserListModel>;
  @useResult
  $Res call({List<UserData> friends});
}

/// @nodoc
class _$UserListModelCopyWithImpl<$Res, $Val extends UserListModel>
    implements $UserListModelCopyWith<$Res> {
  _$UserListModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
  }) {
    return _then(_value.copyWith(
      friends: null == friends
          ? _value.friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<UserData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserListModelImplCopyWith<$Res>
    implements $UserListModelCopyWith<$Res> {
  factory _$$UserListModelImplCopyWith(
          _$UserListModelImpl value, $Res Function(_$UserListModelImpl) then) =
      __$$UserListModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<UserData> friends});
}

/// @nodoc
class __$$UserListModelImplCopyWithImpl<$Res>
    extends _$UserListModelCopyWithImpl<$Res, _$UserListModelImpl>
    implements _$$UserListModelImplCopyWith<$Res> {
  __$$UserListModelImplCopyWithImpl(
      _$UserListModelImpl _value, $Res Function(_$UserListModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserListModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friends = null,
  }) {
    return _then(_$UserListModelImpl(
      friends: null == friends
          ? _value._friends
          : friends // ignore: cast_nullable_to_non_nullable
              as List<UserData>,
    ));
  }
}

/// @nodoc

class _$UserListModelImpl implements _UserListModel {
  const _$UserListModelImpl({final List<UserData> friends = const []})
      : _friends = friends;

  final List<UserData> _friends;
  @override
  @JsonKey()
  List<UserData> get friends {
    if (_friends is EqualUnmodifiableListView) return _friends;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_friends);
  }

  @override
  String toString() {
    return 'UserListModel(friends: $friends)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserListModelImpl &&
            const DeepCollectionEquality().equals(other._friends, _friends));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_friends));

  /// Create a copy of UserListModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserListModelImplCopyWith<_$UserListModelImpl> get copyWith =>
      __$$UserListModelImplCopyWithImpl<_$UserListModelImpl>(this, _$identity);
}

abstract class _UserListModel implements UserListModel {
  const factory _UserListModel({final List<UserData> friends}) =
      _$UserListModelImpl;

  @override
  List<UserData> get friends;

  /// Create a copy of UserListModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserListModelImplCopyWith<_$UserListModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
