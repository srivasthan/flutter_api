import 'package:flutter_api_json_parse/network/entity/amcEntity.dart';
import 'package:flutter_api_json_parse/network/entity/cityEntity.dart';
import 'package:flutter_api_json_parse/network/entity/countryEntity.dart';
import 'package:flutter_api_json_parse/network/entity/emailEntity.dart';
import 'package:flutter_api_json_parse/network/entity/raiseTicketEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class RaiseTicketResponse {
  @JsonKey(name: 'response')
  final RaiseTicketEntity raiseTicketEntity;

  RaiseTicketResponse({this.raiseTicketEntity});

  factory RaiseTicketResponse.fromJson(Map<String, dynamic> json) {
    return RaiseTicketResponse(
      raiseTicketEntity:
          RaiseTicketEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': raiseTicketEntity,
    };
  }
}
