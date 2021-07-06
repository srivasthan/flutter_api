import 'package:flutter_api_json_parse/network/entity/cityEntity.dart';
import 'package:flutter_api_json_parse/network/entity/countryEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CityResponse {
  @JsonKey(name: 'response')
  final CityEntity cityEntity;

  CityResponse({this.cityEntity});

  factory CityResponse.fromJson(Map<String, dynamic> json) {
    return CityResponse(
      cityEntity: CityEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': cityEntity,
    };
  }
}
