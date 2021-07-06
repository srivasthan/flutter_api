import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MyProductListEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final List<MyProductList> myProductList;

  MyProductListEntity({this.responseCode, this.token, this.myProductList});

  factory MyProductListEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<MyProductList> dataList =
        list.map((i) => MyProductList.fromJson(i)).toList();

    return MyProductListEntity(
        responseCode: parsedJson['response_code'],
        token: parsedJson['token'],
        myProductList: dataList);
  }
}

class MyProductList {
  @JsonKey(name: 'contract_id')
  final int contractId;

  @JsonKey(name: 'product')
  final String product;

  @JsonKey(name: 'sub_product')
  final String subProduct;

  @JsonKey(name: 'serial_no')
  final String serialNo;

  @JsonKey(name: 'model_no')
  final String modelNo;

  @JsonKey(name: 'contract_type')
  final String contractType;

  @JsonKey(name: 'contract_status_id')
  final int contractStatusId;

  @JsonKey(name: 'contract_status_name')
  final String contractStatusName;

  MyProductList(
      {this.contractId,
      this.product,
      this.subProduct,
      this.serialNo,
      this.modelNo,
      this.contractType,
      this.contractStatusId,
      this.contractStatusName});

  factory MyProductList.fromJson(Map<String, dynamic> json) {
    return MyProductList(
        contractId: json['contract_id'],
        product: json['product'],
        subProduct: json['sub_product'],
        serialNo: json['serial_no'],
        modelNo: json['model_no'],
        contractType: json['contract_type'],
        contractStatusId: json['contract_status_id'],
        contractStatusName: json['contract_status_name']);
  }
}
