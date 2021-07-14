import 'package:flutter_api_json_parse/network/entity/amcEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AmcResponse {
  @JsonKey(name: 'response')
  final AmcEntity amcEntity;

  AmcResponse({this.amcEntity});

  factory AmcResponse.fromJson(Map<String, dynamic> json) {
    return AmcResponse(
      amcEntity: AmcEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': amcEntity,
    };
  }
}
