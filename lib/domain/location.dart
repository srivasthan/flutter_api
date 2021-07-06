class LocationModel {
  int locationId;
  String locationName;

  LocationModel({this.locationId, this.locationName});

  @override
  String toString() {
    return locationName;
  }
}
