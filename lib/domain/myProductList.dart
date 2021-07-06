class MyProductListModel {
  int contractId;
  String product;
  String subProduct;
  String serialNo;
  String modelNo;
  String contractType;
  int contractStatusId;
  String contractStatusName;

  MyProductListModel(
      {this.contractId,
      this.product,
      this.subProduct,
      this.serialNo,
      this.modelNo,
      this.contractType,
      this.contractStatusId,
      this.contractStatusName});
}
