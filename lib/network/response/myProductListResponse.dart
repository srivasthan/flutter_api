import 'package:flutter_api_json_parse/network/entity/myProductListEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MyProductListResponse {
  @JsonKey(name: 'response')
  final MyProductListEntity myProductListEntity;

  MyProductListResponse({this.myProductListEntity});

  factory MyProductListResponse.fromJson(Map<String, dynamic> json) {
    return MyProductListResponse(
      myProductListEntity: MyProductListEntity.fromJson(
          json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': myProductListEntity,
    };
  }
}
