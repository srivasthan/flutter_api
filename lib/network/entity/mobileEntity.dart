import 'package:json_annotation/json_annotation.dart';
//done this file

@JsonSerializable()
class MobileEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'message')
  final String message;

  MobileEntity({this.responseCode, this.message});

  factory MobileEntity.fromJson(Map<String, dynamic> json) {
    return MobileEntity(
        responseCode: json['response_code'] as String,
        message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'response_code': responseCode, 'message': message};
  }
}
