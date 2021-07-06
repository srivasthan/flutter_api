class SubProductModel {
  int productSubId;
  String productSubName;

  SubProductModel({this.productSubId, this.productSubName});

  @override
  String toString() {
    return productSubName;
  }
}
