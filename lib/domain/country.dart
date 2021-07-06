class CountryModel {
  int countryId;
  String countryName;

  CountryModel({this.countryId, this.countryName});

  @override
  String toString() {
    return countryName;
  }
}