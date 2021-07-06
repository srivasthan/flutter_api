import 'dart:convert';

import 'package:flutter_api_json_parse/network/entity/response_entity.dart';
import 'package:flutter_api_json_parse/network/entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'login_response.dart';

part 'global_response.g.dart';

@JsonSerializable()
class OuterResponse {
  @JsonKey(name: 'response')
  final ResponseEntity responseEntity;

  OuterResponse({this.responseEntity});

  factory OuterResponse.fromJson(Map<String, dynamic> response) =>
      _$ResponseFromJson(response);

  Map<String, dynamic> toJson() => _$ResponseToJson(this);
}
