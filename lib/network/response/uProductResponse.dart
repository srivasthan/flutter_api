import 'package:flutter_api_json_parse/network/entity/productEntity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_api_json_parse/network/entity/uProductEntity.dart';

@JsonSerializable()
class UProductResponse {
  @JsonKey(name: 'response')
  final UProductEntity uproductEntity;

  UProductResponse({this.uproductEntity});

  factory UProductResponse.fromJson(Map<String, dynamic> json) {
    return UProductResponse(
      uproductEntity:
      UProductEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': uproductEntity,
    };
  }
}