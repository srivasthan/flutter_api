import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_api_json_parse/network/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';
//done this file

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'customer_details')
  final Source userEntity;

  @JsonKey(name: 'message')
  final String message;

  LoginResponse({this.responseCode, this.token, this.userEntity, this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

class Source {
  String code;
  String name;

  Source({this.code, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      code: json["customer_code"] as String,
      name: json["customer_name"] as String,
    );
  }
}
