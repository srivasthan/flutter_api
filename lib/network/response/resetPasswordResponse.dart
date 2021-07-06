import 'package:flutter_api_json_parse/network/entity/resetPasswordEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ResetPasswordResponse {
  @JsonKey(name: 'response')
  final ResetPasswordEntity resetPasswordEntity;

  ResetPasswordResponse({this.resetPasswordEntity});

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      resetPasswordEntity: ResetPasswordEntity.fromJson(
          json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': resetPasswordEntity,
    };
  }
}
