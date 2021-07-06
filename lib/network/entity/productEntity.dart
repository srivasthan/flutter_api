import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ProductEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<Product> datum;

  ProductEntity({this.responseCode, this.datum});

  factory ProductEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Product> dataList = list.map((i) => Product.fromJson(i)).toList();

    return ProductEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class Product {
  @JsonKey(name: 'product_id')
  final int prouductId;

  @JsonKey(name: 'product_name')
  final String productName;

  Product({this.prouductId, this.productName});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
        prouductId: parsedJson['product_id'],
        productName: parsedJson['product_name']);
  }
}
