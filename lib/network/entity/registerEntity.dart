import 'package:json_annotation/json_annotation.dart';
//done this file

@JsonSerializable()
class RegisterEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'message')
  final String message;

  RegisterEntity({this.responseCode, this.token, this.message});

  factory RegisterEntity.fromJson(Map<String, dynamic> json) {
    return RegisterEntity(
        responseCode: json['response_code'] as String,
        token: json['token'] as String,
        message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'response_code': responseCode, 'token': token, 'message': message};
  }
}
