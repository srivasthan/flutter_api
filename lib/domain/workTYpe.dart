class WorkModel {
  int workTypeId;
  String workType;

  WorkModel({this.workTypeId, this.workType});

  @override
  String toString() {
    return workType;
  }
}
