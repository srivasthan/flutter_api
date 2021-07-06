// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    responseCode: json['response_code'] as String,
    token: json['token'] as String,
    userEntity: Source.fromJson(json["customer_details"]),
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'token': instance.token,
      'customer_details': instance.userEntity,
      'message': instance.message,
    };