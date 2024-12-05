// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      id: json['id'] as String,
      nationId: json['nationId'] as String?,
      email: json['email'] as String,
      name: json['name'] as String,
      profileUrl: json['profileUrl'] as String?,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nationId': instance.nationId,
      'email': instance.email,
      'name': instance.name,
      'profileUrl': instance.profileUrl,
    };
