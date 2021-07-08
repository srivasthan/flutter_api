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

  @JsonKey(name: 'street')
  final String street;

  @JsonKey(name: 'landmark')
  final String landmark;

  @JsonKey(name: 'country_id')
  final int countryId;

  @JsonKey(name: 'state_id')
  final int stateId;

  @JsonKey(name: 'city_id')
  final int cityId;

  @JsonKey(name: 'location_id')
  final int locationId;

  @JsonKey(name: 'post_code')
  final int postCode;

  UserEntity(
      {this.cusCode,
      this.cusName,
      this.email,
      this.phone,
      this.alternateNumber,
      this.plotNumber,
      this.street,
      this.landmark,
      this.countryId,
      this.stateId,
      this.cityId,
      this.locationId,
      this.postCode});

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
