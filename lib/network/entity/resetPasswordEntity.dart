import 'package:json_annotation/json_annotation.dart';
//done this file

@JsonSerializable()
class ResetPasswordEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'message')
  final String message;

  ResetPasswordEntity({this.responseCode, this.message});

  factory ResetPasswordEntity.fromJson(Map<String, dynamic> json) {
    return ResetPasswordEntity(
        responseCode: json['response_code'] as String,
        message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'response_code': responseCode, 'message': message};
  }
}
