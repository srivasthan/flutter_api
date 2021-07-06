// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OuterResponse _$ResponseFromJson(Map<String, dynamic> json) {
  return OuterResponse(
    responseEntity:
        ResponseEntity.fromJson(json['response'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResponseToJson(OuterResponse instance) =>
    <String, dynamic>{
      'response': instance.responseEntity,
    };
