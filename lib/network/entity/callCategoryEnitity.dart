import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class CallCategoryEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<CallCategory> datum;

  CallCategoryEntity({this.responseCode, this.datum});

  factory CallCategoryEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<CallCategory> dataList =
        list.map((i) => CallCategory.fromJson(i)).toList();

    return CallCategoryEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class CallCategory {
  @JsonKey(name: 'call_category_id')
  final int callCategoryId;

  @JsonKey(name: 'call_category')
  final String callCategory;

  CallCategory({this.callCategoryId, this.callCategory});

  factory CallCategory.fromJson(Map<String, dynamic> parsedJson) {
    return CallCategory(
        callCategoryId: parsedJson['call_category_id'],
        callCategory: parsedJson['call_category']);
  }
}
