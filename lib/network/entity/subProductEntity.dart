import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SubProductEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<SubProduct> datum;

  SubProductEntity({this.responseCode, this.datum});

  factory SubProductEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<SubProduct> dataList =
        list.map((i) => SubProduct.fromJson(i)).toList();

    return SubProductEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class SubProduct {
  @JsonKey(name: 'product_sub_id')
  final int prouductSubId;

  @JsonKey(name: 'product_sub_name')
  final String productSubName;

  SubProduct({this.prouductSubId, this.productSubName});

  factory SubProduct.fromJson(Map<String, dynamic> parsedJson) {
    return SubProduct(
        prouductSubId: parsedJson['product_sub_id'],
        productSubName: parsedJson['product_sub_name']);
  }
}
