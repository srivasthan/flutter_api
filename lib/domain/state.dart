class StateModel {
  int stateId;
  String stateName;

  StateModel({this.stateId, this.stateName});

  @override
  String toString() {
    return stateName;
  }
}
