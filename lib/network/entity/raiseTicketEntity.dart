import 'package:json_annotation/json_annotation.dart';
//done this file

@JsonSerializable()
class RaiseTicketEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'message')
  final String message;

  RaiseTicketEntity({this.responseCode, this.message});

  factory RaiseTicketEntity.fromJson(Map<String, dynamic> json) {
    return RaiseTicketEntity(
        responseCode: json['response_code'] as String,
        message: json['message'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'response_code': responseCode, 'message': message};
  }
}
