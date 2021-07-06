// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return ResponseEntity(
    responseCode: json['response_code'] as String,
    token: json['token'] as String,
    userEntity:
        UserEntity.fromJson(json['customer_details'] as Map<String, dynamic>),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$UserEntityToJson(ResponseEntity instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'token': instance.token,
      'customer_details': instance.userEntity,
      'message': instance.message,
    };
