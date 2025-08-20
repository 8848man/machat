// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return _Chat.fromJson(json);
}

/// @nodoc
mixin _$Chat {
  String get id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  String get createdAt => throw _privateConstructorUsedError;
  bool get isMine => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get imageUrl => throw _privateConstructorUsedError;
  List<String> get deletedTo => throw _privateConstructorUsedError;
  bool get isDeletedForEveryone => throw _privateConstructorUsedError;

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatCopyWith<Chat> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatCopyWith<$Res> {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) then) =
      _$ChatCopyWithImpl<$Res, Chat>;
  @useResult
  $Res call(
      {String id,
      String message,
      String createdBy,
      String createdAt,
      bool isMine,
      String type,
      String imageUrl,
      List<String> deletedTo,
      bool isDeletedForEveryone});
}

/// @nodoc
class _$ChatCopyWithImpl<$Res, $Val extends Chat>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? isMine = null,
    Object? type = null,
    Object? imageUrl = null,
    Object? deletedTo = null,
    Object? isDeletedForEveryone = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deletedTo: null == deletedTo
          ? _value.deletedTo
          : deletedTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDeletedForEveryone: null == isDeletedForEveryone
          ? _value.isDeletedForEveryone
          : isDeletedForEveryone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatImplCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$$ChatImplCopyWith(
          _$ChatImpl value, $Res Function(_$ChatImpl) then) =
      __$$ChatImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String message,
      String createdBy,
      String createdAt,
      bool isMine,
      String type,
      String imageUrl,
      List<String> deletedTo,
      bool isDeletedForEveryone});
}

/// @nodoc
class __$$ChatImplCopyWithImpl<$Res>
    extends _$ChatCopyWithImpl<$Res, _$ChatImpl>
    implements _$$ChatImplCopyWith<$Res> {
  __$$ChatImplCopyWithImpl(_$ChatImpl _value, $Res Function(_$ChatImpl) _then)
      : super(_value, _then);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? message = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? isMine = null,
    Object? type = null,
    Object? imageUrl = null,
    Object? deletedTo = null,
    Object? isDeletedForEveryone = null,
  }) {
    return _then(_$ChatImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String,
      isMine: null == isMine
          ? _value.isMine
          : isMine // ignore: cast_nullable_to_non_nullable
              as bool,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      deletedTo: null == deletedTo
          ? _value._deletedTo
          : deletedTo // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isDeletedForEveryone: null == isDeletedForEveryone
          ? _value.isDeletedForEveryone
          : isDeletedForEveryone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatImpl implements _Chat {
  const _$ChatImpl(
      {this.id = '',
      required this.message,
      required this.createdBy,
      required this.createdAt,
      this.isMine = false,
      this.type = 'chat',
      this.imageUrl = '',
      final List<String> deletedTo = const [],
      this.isDeletedForEveryone = false})
      : _deletedTo = deletedTo;

  factory _$ChatImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  final String message;
  @override
  final String createdBy;
  @override
  final String createdAt;
  @override
  @JsonKey()
  final bool isMine;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey()
  final String imageUrl;
  final List<String> _deletedTo;
  @override
  @JsonKey()
  List<String> get deletedTo {
    if (_deletedTo is EqualUnmodifiableListView) return _deletedTo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_deletedTo);
  }

  @override
  @JsonKey()
  final bool isDeletedForEveryone;

  @override
  String toString() {
    return 'Chat(id: $id, message: $message, createdBy: $createdBy, createdAt: $createdAt, isMine: $isMine, type: $type, imageUrl: $imageUrl, deletedTo: $deletedTo, isDeletedForEveryone: $isDeletedForEveryone)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.isMine, isMine) || other.isMine == isMine) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality()
                .equals(other._deletedTo, _deletedTo) &&
            (identical(other.isDeletedForEveryone, isDeletedForEveryone) ||
                other.isDeletedForEveryone == isDeletedForEveryone));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      message,
      createdBy,
      createdAt,
      isMine,
      type,
      imageUrl,
      const DeepCollectionEquality().hash(_deletedTo),
      isDeletedForEveryone);

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      __$$ChatImplCopyWithImpl<_$ChatImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatImplToJson(
      this,
    );
  }
}

abstract class _Chat implements Chat {
  const factory _Chat(
      {final String id,
      required final String message,
      required final String createdBy,
      required final String createdAt,
      final bool isMine,
      final String type,
      final String imageUrl,
      final List<String> deletedTo,
      final bool isDeletedForEveryone}) = _$ChatImpl;

  factory _Chat.fromJson(Map<String, dynamic> json) = _$ChatImpl.fromJson;

  @override
  String get id;
  @override
  String get message;
  @override
  String get createdBy;
  @override
  String get createdAt;
  @override
  bool get isMine;
  @override
  String get type;
  @override
  String get imageUrl;
  @override
  List<String> get deletedTo;
  @override
  bool get isDeletedForEveryone;

  /// Create a copy of Chat
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatImplCopyWith<_$ChatImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
