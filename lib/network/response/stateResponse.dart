import 'package:flutter_api_json_parse/network/entity/countryEntity.dart';
import 'package:flutter_api_json_parse/network/entity/stateEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StateResponse {
  @JsonKey(name: 'response')
  final StateEntity stateEntity;

  StateResponse({this.stateEntity});

  factory StateResponse.fromJson(Map<String, dynamic> json) {
    return StateResponse(
      stateEntity:
          StateEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': stateEntity,
    };
  }
}
