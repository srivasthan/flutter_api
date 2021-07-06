import 'package:flutter_api_json_parse/network/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_entity.g.dart';
//done this file

@JsonSerializable()
class ResponseEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'customer_details')
  final UserEntity userEntity;

  @JsonKey(name: 'message')
  final String message;

  ResponseEntity(
      {this.responseCode, this.token, this.userEntity, this.message});

  factory ResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
