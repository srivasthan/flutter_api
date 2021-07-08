import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AmcListEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final List<AmcList> amcList;

  AmcListEntity({this.responseCode, this.token, this.amcList});

  factory AmcListEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<AmcList> dataList = list.map((i) => AmcList.fromJson(i)).toList();

    return AmcListEntity(
        responseCode: parsedJson['response_code'],
        token: parsedJson['token'],
        amcList: dataList);
  }
}

class AmcList {
  @JsonKey(name: 'customer_name')
  final String customerName;

  @JsonKey(name: 'product')
  final String product;

  @JsonKey(name: 'sub_product')
  final String subProduct;

  @JsonKey(name: 'serial_no')
  final String serialNo;

  @JsonKey(name: 'model_no')
  final String modelNo;

  @JsonKey(name: 'amc_type')
  final String contractType;

  @JsonKey(name: 'days_left')
  final int contractStatusName;

  AmcList(
      {this.customerName,
      this.product,
      this.subProduct,
      this.serialNo,
      this.modelNo,
      this.contractType,
      this.contractStatusName});

  factory AmcList.fromJson(Map<String, dynamic> json) {
    return AmcList(
        customerName: json['customer_name'],
        product: json['product'],
        subProduct: json['sub_product'],
        serialNo: json['serial_no'],
        modelNo: json['model_no'],
        contractType: json['amc_type'],
        contractStatusName: json['days_left']);
  }
}
