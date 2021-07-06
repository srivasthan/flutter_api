import 'package:flutter_api_json_parse/network/entity/countryEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CountryResponse {
  @JsonKey(name: 'response')
  final CountryEntity countryEntity;

  CountryResponse({this.countryEntity});

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      countryEntity:
          CountryEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }
//
Map<String, dynamic> toJson(){
  return{
    'response': countryEntity,
  };
}

}
