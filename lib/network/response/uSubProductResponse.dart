import 'package:flutter_api_json_parse/network/entity/productEntity.dart';
import 'package:flutter_api_json_parse/network/entity/uSubProductEntity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_api_json_parse/network/entity/uProductEntity.dart';

@JsonSerializable()
class USubProductResponse {
  @JsonKey(name: 'response')
  final USubProductEntity uSubProductEntity;

  USubProductResponse({this.uSubProductEntity});

  factory USubProductResponse.fromJson(Map<String, dynamic> json) {
    return USubProductResponse(
      uSubProductEntity:
          USubProductEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': uSubProductEntity,
    };
  }
}
