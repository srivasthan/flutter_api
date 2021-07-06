import 'package:flutter_api_json_parse/network/entity/mobileEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MobileResponse {
  @JsonKey(name: 'response')
  final MobileEntity mobileEntity;

  MobileResponse({this.mobileEntity});

  factory MobileResponse.fromJson(Map<String, dynamic> json) {
    return MobileResponse(
      mobileEntity:
          MobileEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': mobileEntity,
    };
  }
}
