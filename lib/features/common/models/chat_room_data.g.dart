// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatRoomDataImpl _$$ChatRoomDataImplFromJson(Map<String, dynamic> json) =>
    _$ChatRoomDataImpl(
      roomId: json['roomId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      members: json['members'] as List<dynamic>? ?? const [],
      name: json['name'] as String? ?? '',
      isMine: json['isMine'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatRoomDataImplToJson(_$ChatRoomDataImpl instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'members': instance.members,
      'name': instance.name,
      'isMine': instance.isMine,
    };
