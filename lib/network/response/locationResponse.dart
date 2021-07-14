import 'package:flutter_api_json_parse/network/entity/locationEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LocationResponse {
  @JsonKey(name: 'response')
  final LocationEntity locationEntity;

  LocationResponse({this.locationEntity});

  factory LocationResponse.fromJson(Map<String, dynamic> json) {
    return LocationResponse(
      locationEntity:
          LocationEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

//
  Map<String, dynamic> toJson() {
    return {
      'response': locationEntity,
    };
  }
}
