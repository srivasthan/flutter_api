import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LocationEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<Location> datum;

  LocationEntity({this.responseCode, this.datum});

  factory LocationEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Location> dataList = list.map((i) => Location.fromJson(i)).toList();

    return LocationEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class Location {
  @JsonKey(name: 'location_id')
  final int locationId;

  @JsonKey(name: 'location_name')
  final String locationName;

  Location({this.locationId, this.locationName});

  factory Location.fromJson(Map<String, dynamic> parsedJson) {
    return Location(
        locationId: parsedJson['location_id'],
        locationName: parsedJson['location_name']);
  }
}
