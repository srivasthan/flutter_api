import 'package:flutter_api_json_parse/network/entity/workType.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class WorkResponse {
  @JsonKey(name: 'response')
  final WorkEntity workEntity;

  WorkResponse({this.workEntity});

  factory WorkResponse.fromJson(Map<String, dynamic> json) {
    return WorkResponse(
      workEntity: WorkEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': workEntity,
    };
  }
}
