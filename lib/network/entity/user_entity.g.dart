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
    };
