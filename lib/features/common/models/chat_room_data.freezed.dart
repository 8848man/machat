// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_room_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChatRoomData _$ChatRoomDataFromJson(Map<String, dynamic> json) {
  return _ChatRoomData.fromJson(json);
}

/// @nodoc
mixin _$ChatRoomData {
  String get roomId => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  List<String> get members => throw _privateConstructorUsedError;
  List<RoomUserData> get membersHistory => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  bool get isMine => throw _privateConstructorUsedError;

  /// Serializes this ChatRoomData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatRoomData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatRoomDataCopyWith<ChatRoomData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatRoomDataCopyWith<$Res> {
  factory $ChatRoomDataCopyWith(
          ChatRoomData value, $Res Function(ChatRoomData) then) =
      _$ChatRoomDataCopyWithImpl<$Res, ChatRoomData>;
  @useResult
  $Res call(
      {String roomId,
      String createdBy,
      String? createdAt,
      List<String> members,
      List<RoomUserData> membersHistory,
      String name,
      bool isMine});
}

/// @nodoc
class _$ChatRoomDataCopyWithImpl<$Res, $Val extends ChatRoomData>
    implements $ChatRoomDataCopyWith<$Res> {
  _$ChatRoomDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatRoomData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? members = null,
    Object? membersHistory = null,
    Object? name = null,
    Object? isMine = null,
  }) {
    return _then(_value.copyWith(
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      membersHistory: null == membersHistory
          ? _value.membersHistory
          : membersHistory // ignore: cast_nullable_to_non_nullable
              as List<RoomUserData>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatRoomDataImplCopyWith<$Res>
    implements $ChatRoomDataCopyWith<$Res> {
  factory _$$ChatRoomDataImplCopyWith(
          _$ChatRoomDataImpl value, $Res Function(_$ChatRoomDataImpl) then) =
      __$$ChatRoomDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String roomId,
      String createdBy,
      String? createdAt,
      List<String> members,
      List<RoomUserData> membersHistory,
      String name,
      bool isMine});
}

/// @nodoc
class __$$ChatRoomDataImplCopyWithImpl<$Res>
    extends _$ChatRoomDataCopyWithImpl<$Res, _$ChatRoomDataImpl>
    implements _$$ChatRoomDataImplCopyWith<$Res> {
  __$$ChatRoomDataImplCopyWithImpl(
      _$ChatRoomDataImpl _value, $Res Function(_$ChatRoomDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatRoomData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roomId = null,
    Object? createdBy = null,
    Object? createdAt = freezed,
    Object? members = null,
    Object? membersHistory = null,
    Object? name = null,
    Object? isMine = null,
  }) {
    return _then(_$ChatRoomDataImpl(
      roomId: null == roomId
          ? _value.roomId
          : roomId // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<String>,
      membersHistory: null == membersHistory
          ? _value._membersHistory
          : membersHistory // ignore: cast_nullable_to_non_nullable
              as List<RoomUserData>,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatRoomDataImpl implements _ChatRoomData {
  const _$ChatRoomDataImpl(
      {this.roomId = '',
      this.createdBy = '',
      this.createdAt,
      final List<String> members = const [],
      final List<RoomUserData> membersHistory = const [],
      this.name = '',
      this.isMine = false})
      : _members = members,
        _membersHistory = membersHistory;

  factory _$ChatRoomDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatRoomDataImplFromJson(json);

  @override
  @JsonKey()
  final String roomId;
  @override
  @JsonKey()
  final String createdBy;
  @override
  final String? createdAt;
  final List<String> _members;
  @override
  @JsonKey()
  List<String> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<RoomUserData> _membersHistory;
  @override
  @JsonKey()
  List<RoomUserData> get membersHistory {
    if (_membersHistory is EqualUnmodifiableListView) return _membersHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_membersHistory);
  }

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final bool isMine;

  @override
  String toString() {
    return 'ChatRoomData(roomId: $roomId, createdBy: $createdBy, createdAt: $createdAt, members: $members, membersHistory: $membersHistory, name: $name, isMine: $isMine)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatRoomDataImpl &&
            (identical(other.roomId, roomId) || other.roomId == roomId) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality()
                .equals(other._membersHistory, _membersHistory) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.isMine, isMine) || other.isMine == isMine));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      roomId,
      createdBy,
      createdAt,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_membersHistory),
      name,
      isMine);

  /// Create a copy of ChatRoomData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatRoomDataImplCopyWith<_$ChatRoomDataImpl> get copyWith =>
      __$$ChatRoomDataImplCopyWithImpl<_$ChatRoomDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatRoomDataImplToJson(
      this,
    );
  }
}

abstract class _ChatRoomData implements ChatRoomData {
  const factory _ChatRoomData(
      {final String roomId,
      final String createdBy,
      final String? createdAt,
      final List<String> members,
      final List<RoomUserData> membersHistory,
      final String name,
      final bool isMine}) = _$ChatRoomDataImpl;

  factory _ChatRoomData.fromJson(Map<String, dynamic> json) =
      _$ChatRoomDataImpl.fromJson;

  @override
  String get roomId;
  @override
  String get createdBy;
  @override
  String? get createdAt;
  @override
  List<String> get members;
  @override
  List<RoomUserData> get membersHistory;
  @override
  String get name;
  @override
  bool get isMine;

  /// Create a copy of ChatRoomData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatRoomDataImplCopyWith<_$ChatRoomDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
