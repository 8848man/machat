// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      message: json['message'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: json['createdAt'] as String,
      isMine: json['isMine'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
      'isMine': instance.isMine,
    };
