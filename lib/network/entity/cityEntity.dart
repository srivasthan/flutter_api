import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CityEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<City> datum;

  CityEntity({this.responseCode, this.datum});

  factory CityEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<City> dataList = list.map((i) => City.fromJson(i)).toList();

    return CityEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class City {
  @JsonKey(name: 'city_id')
  final int cityId;

  @JsonKey(name: 'city_name')
  final String cityName;

  City({this.cityId, this.cityName});

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
        cityId: parsedJson['city_id'], cityName: parsedJson['city_name']);
  }
}
