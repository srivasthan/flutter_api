// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity(
    cusCode: json['customer_code'] as String,
    cusName: json['customer_name'] as String,
    email: json['email_id'] as String,
    phone: json['contact_number'] as String,
    alternateNumber: json['alternate_number'] as String,
    plotNumber: json['plot_number'] as String,
    street: json['street'] as String,
    landmark: json['landmark'] as String,
    countryId: json['country_id'] as int,
    stateId: json['state_id'] as int,
    cityId: json['city_id'] as int,
    locationId: json['location_id'] as int,
    postCode: json['post_code'] as int,
  );
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'customer_code': instance.cusCode,
      'customer_name': instance.cusName,
      'email_id': instance.email,
      'contact_number': instance.phone,
      'alternate_number': instance.alternateNumber,
      'plot_number': instance.plotNumber,
      'street': instance.street,
      'landmark': instance.landmark,
      'country_id': instance.countryId,
      'state_id': instance.stateId,
      'city_id': instance.cityId,
      'location_id': instance.locationId,
      'post_code': instance.postCode,
    };
