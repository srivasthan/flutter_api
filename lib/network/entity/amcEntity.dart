import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AmcEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<Amc> datum;

  AmcEntity({this.responseCode, this.datum});

  factory AmcEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<Amc> dataList = list.map((i) => Amc.fromJson(i)).toList();

    return AmcEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class Amc {
  @JsonKey(name: 'amc_id')
  final int amcId;

  @JsonKey(name: 'amc_type')
  final String amcType;

  @JsonKey(name: 'duration')
  final int duration;

  Amc({this.amcId, this.amcType, this.duration});

  factory Amc.fromJson(Map<String, dynamic> parsedJson) {
    return Amc(
        amcId: parsedJson['amc_id'],
        amcType: parsedJson['amc_type'],
        duration: parsedJson['duration']);
  }
}
