import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CountryEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<Country> datum;

  CountryEntity({this.responseCode, this.datum});

  factory CountryEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Country> dataList = list.map((i) => Country.fromJson(i)).toList();

    return CountryEntity(responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class Country {
  @JsonKey(name: 'country_id')
  final int countryId;

  @JsonKey(name: 'country_name')
  final String countryName;

  Country({this.countryId, this.countryName});

  factory Country.fromJson(Map<String, dynamic> parsedJson) {
    return Country(
        countryId: parsedJson['country_id'],
        countryName: parsedJson['country_name']);
  }
}
