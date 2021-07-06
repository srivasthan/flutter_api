class AmcModel {
  int amcId;
  String amcName;
  int duration;

  AmcModel({this.amcId, this.amcName, this.duration});

  @override
  String toString() {
    return amcName;
  }
}
