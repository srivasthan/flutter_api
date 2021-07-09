import 'package:flutter_api_json_parse/network/entity/serialNumberEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SerialNumberResponse {
  @JsonKey(name: 'response')
  final SerialNumberEntity serialNumberEntity;

  SerialNumberResponse({this.serialNumberEntity});

  factory SerialNumberResponse.fromJson(Map<String, dynamic> json) {
    return SerialNumberResponse(
      serialNumberEntity:
          SerialNumberEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': serialNumberEntity,
    };
  }
}
