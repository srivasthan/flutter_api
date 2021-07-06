import 'package:flutter_api_json_parse/network/entity/registerEntity.dart';
import 'package:flutter_api_json_parse/network/entity/tokenEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class TokenResponse {
  @JsonKey(name: 'response')
  final TokenEntity tokenEntity;

  TokenResponse({this.tokenEntity});

  factory TokenResponse.fromJson(Map<String, dynamic> json) {
    return TokenResponse(
      tokenEntity:
          TokenEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': tokenEntity,
    };
  }
}
