import 'package:flutter_api_json_parse/network/entity/productEntity.dart';
import 'package:flutter_api_json_parse/network/entity/subProductEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SubProductResponse {
  @JsonKey(name: 'response')
  final SubProductEntity subProductEntity;

  SubProductResponse({this.subProductEntity});

  factory SubProductResponse.fromJson(Map<String, dynamic> json) {
    return SubProductResponse(
      subProductEntity:
          SubProductEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': subProductEntity,
    };
  }
}
