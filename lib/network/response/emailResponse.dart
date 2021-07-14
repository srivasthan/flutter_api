import 'package:flutter_api_json_parse/network/entity/emailEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EmailResponse {
  @JsonKey(name: 'response')
  final EmailEntity emailEntity;

  EmailResponse({this.emailEntity});

  factory EmailResponse.fromJson(Map<String, dynamic> json) {
    return EmailResponse(
      emailEntity:
          EmailEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': emailEntity,
    };
  }
}
