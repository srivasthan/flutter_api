import 'package:json_annotation/json_annotation.dart';

part 'profileStoreEntity.g.dart';

//done this file

@JsonSerializable()
class ProfileSaveEntity {
  @JsonKey(name: 'customer_name')
  final String cusName;

  @JsonKey(name: 'email_id')
  final String email;

  @JsonKey(name: 'contact_number')
  final String phone;

  @JsonKey(name: 'alternate_number')
  final String alternateNumber;

  ProfileSaveEntity(
      {this.cusName, this.email, this.phone, this.alternateNumber});

  factory ProfileSaveEntity.fromJson(Map<String, dynamic> json) =>
      _$ProfileSaveEntityFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileSaveEntityToJson(this);
}
