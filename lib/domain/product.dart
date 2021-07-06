class ProductModel {
  int productId;
  String productName;

  ProductModel({this.productId, this.productName});

  @override
  String toString() {
    return productName;
  }
}
