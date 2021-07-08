class AmcModel {
  int amcId;
  String amcName;
  double cost;
  int duration;

  AmcModel({this.amcId, this.amcName, this.cost, this.duration});

  @override
  String toString() {
    return amcName;
  }
}
