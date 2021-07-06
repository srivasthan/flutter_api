import 'package:flutter_api_json_parse/network/entity/productEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductResponse {
  @JsonKey(name: 'response')
  final ProductEntity productEntity;

  ProductResponse({this.productEntity});

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      productEntity:
          ProductEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': productEntity,
    };
  }
}
