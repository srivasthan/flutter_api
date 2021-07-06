import 'package:flutter_api_json_parse/network/entity/registerEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'response')
  final RegisterEntity responseEntity;

  RegisterResponse({this.responseEntity});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      responseEntity:
          RegisterEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': responseEntity,
    };
  }
}
