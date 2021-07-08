import 'package:flutter_api_json_parse/network/entity/amcListEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AmcListResponse {
  @JsonKey(name: 'response')
  final AmcListEntity amcListEntity;

  AmcListResponse({this.amcListEntity});

  factory AmcListResponse.fromJson(Map<String, dynamic> json) {
    return AmcListResponse(
      amcListEntity:
          AmcListEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': amcListEntity,
    };
  }
}
