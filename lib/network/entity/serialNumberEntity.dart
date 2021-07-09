import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class SerialNumberEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'token')
  final String token;

  @JsonKey(name: 'data')
  final List<SerialNumber> datum;

  SerialNumberEntity({this.responseCode, this.token, this.datum});

  factory SerialNumberEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<SerialNumber> dataList =
        list.map((i) => SerialNumber.fromJson(i)).toList();

    return SerialNumberEntity(
        responseCode: parsedJson['response_code'],
        token: parsedJson['token'],
        datum: dataList);
  }
}

class SerialNumber {
  @JsonKey(name: 'customer_contract_id')
  final int customerContractId;

  @JsonKey(name: 'model_no')
  final String modelNo;

  @JsonKey(name: 'serial_no')
  final String serialNo;

  @JsonKey(name: 'contract_type_id')
  final int contractTypeId;

  @JsonKey(name: 'contract_type')
  final String contractType;

  @JsonKey(name: 'duration')
  final int duration;

  SerialNumber(
      {this.customerContractId,
      this.modelNo,
      this.serialNo,
      this.contractTypeId,
      this.contractType,
      this.duration});

  factory SerialNumber.fromJson(Map<String, dynamic> parsedJson) {
    return SerialNumber(
        customerContractId: parsedJson['customer_contract_id'],
        modelNo: parsedJson['model_no'],
        serialNo: parsedJson['serial_no'],
        contractTypeId: parsedJson['contract_type_id'],
        contractType: parsedJson['contract_type'],
        duration: parsedJson['duration']);
  }
}
