import 'package:json_annotation/json_annotation.dart';

part 'user_entity.g.dart';

//done this file

@JsonSerializable()
class UserEntity {
  @JsonKey(name: 'customer_code')
  final String cusCode;

  @JsonKey(name: 'customer_name')
  final String cusName;

  @JsonKey(name: 'email_id')
  final String email;

  @JsonKey(name: 'contact_number')
  final String phone;

  @JsonKey(name: 'alternate_number')
  final String alternateNumber;

  @JsonKey(name: 'plot_number')
  final String plotNumber;

  UserEntity(
      {this.cusCode,
      this.cusName,
      this.email,
      this.phone,
      this.alternateNumber,
      this.plotNumber});

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
