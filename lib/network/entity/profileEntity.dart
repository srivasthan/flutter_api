import 'package:flutter_api_json_parse/network/entity/profileSaveEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tokenEntity.g.dart';

@JsonSerializable()
class ProfileEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final ProfileSaveEntity profileSaveEntity;

  ProfileEntity({this.responseCode, this.token, this.profileSaveEntity});

  factory ProfileEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileEntityToJson(this);
}
