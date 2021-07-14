import 'package:flutter_api_json_parse/network/entity/profileEntity.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProfileResponse {
  @JsonKey(name: 'response')
  final ProfileEntity profileEntity;

  ProfileResponse({this.profileEntity});

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      profileEntity:
          ProfileEntity.fromJson(json['response'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': profileEntity,
    };
  }
}
