import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class USubProductEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final List<SubProduct> datum;

  USubProductEntity({this.responseCode, this.token, this.datum});

  factory USubProductEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<SubProduct> dataList =
        list.map((i) => SubProduct.fromJson(i)).toList();

    return USubProductEntity(
        responseCode: parsedJson['response_code'],
        token: parsedJson['token'],
        datum: dataList);
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
