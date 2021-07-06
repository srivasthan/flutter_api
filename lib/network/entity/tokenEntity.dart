import 'package:json_annotation/json_annotation.dart';
//done this file

@JsonSerializable()
class TokenEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final String data;

  TokenEntity({this.responseCode, this.data});

  factory TokenEntity.fromJson(Map<String, dynamic> json) {
    return TokenEntity(
        responseCode: json['response_code'] as String,
        data: json['data'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'response_code': responseCode, 'data': data};
  }
}
