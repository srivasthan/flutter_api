import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class WorkEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<WorkType> datum;

  WorkEntity({this.responseCode, this.datum});

  factory WorkEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<WorkType> dataList = list.map((i) => WorkType.fromJson(i)).toList();

    return WorkEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class WorkType {
  @JsonKey(name: 'work_type_id')
  final int workTypeId;

  @JsonKey(name: 'work_type')
  final String workType;

  WorkType({this.workTypeId, this.workType});

  factory WorkType.fromJson(Map<String, dynamic> parsedJson) {
    return WorkType(
        workTypeId: parsedJson['work_type_id'],
        workType: parsedJson['work_type']);
  }
}
