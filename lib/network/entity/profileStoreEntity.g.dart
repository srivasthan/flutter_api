// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileSaveEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileSaveEntity _$ProfileSaveEntityFromJson(Map<String, dynamic> json) {
  return ProfileSaveEntity(
    cusName: json['customer_name'] as String,
    email: json['email_id'] as String,
    phone: json['contact_number'] as String,
    alternateNumber: json['alternate_number'] as String,
  );
}

Map<String, dynamic> _$ProfileSaveEntityToJson(ProfileSaveEntity instance) =>
    <String, dynamic>{
      'customer_name': instance.cusName,
      'email_id': instance.email,
      'contact_number': instance.phone,
      'alternate_number': instance.alternateNumber,
    };
