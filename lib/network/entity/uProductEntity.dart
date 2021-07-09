import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class UProductEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final List<UProduct> datum;

  UProductEntity({this.responseCode, this.token, this.datum});

  factory UProductEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<UProduct> dataList = list.map((i) => UProduct.fromJson(i)).toList();

    return UProductEntity(
        responseCode: parsedJson['response_code'],
        token: parsedJson['token'],
        datum: dataList);
  }
}

class UProduct {
  @JsonKey(name: 'product_id')
  final int prouductId;

  @JsonKey(name: 'product_name')
  final String productName;

  UProduct({this.prouductId, this.productName});

  factory UProduct.fromJson(Map<String, dynamic> parsedJson) {
    return UProduct(
        prouductId: parsedJson['product_id'],
        productName: parsedJson['product_name']);
  }
}
