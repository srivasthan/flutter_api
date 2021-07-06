// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileEntity _$ProfileEntityFromJson(Map<String, dynamic> json) {
  return ProfileEntity(
    responseCode: json['response_code'] as String,
    token: json['token'] as String,
    profileSaveEntity:
        ProfileSaveEntity.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ProfileEntityToJson(ProfileEntity instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'token': instance.token,
      'data': instance.profileSaveEntity,
    };
