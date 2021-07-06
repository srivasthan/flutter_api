class CityModel {
  int cityId;
  String cityName;

  CityModel({this.cityId, this.cityName});

  @override
  String toString() {
    return cityName;
  }
}
