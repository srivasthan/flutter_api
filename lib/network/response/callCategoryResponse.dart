import 'package:flutter_api_json_parse/network/entity/callCategoryEnitity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CallCategoryResponse {
  @JsonKey(name: 'response')
  final CallCategoryEntity callCategoryEntity;

  CallCategoryResponse({this.callCategoryEntity});

  factory CallCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CallCategoryResponse(
      callCategoryEntity:
          CallCategoryEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': callCategoryEntity,
    };
  }
}
