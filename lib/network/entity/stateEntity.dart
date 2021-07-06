import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class StateEntity {
  @JsonKey(name: 'response_code')
  final String responseCode;

  @JsonKey(name: 'data')
  final List<State> datum;

  StateEntity({this.responseCode, this.datum});

  factory StateEntity.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<State> dataList = list.map((i) => State.fromJson(i)).toList();

    return StateEntity(
        responseCode: parsedJson['response_code'], datum: dataList);
  }
}

class State {
  @JsonKey(name: 'state_id')
  final int stateId;

  @JsonKey(name: 'state_name')
  final String stateName;

  State({this.stateId, this.stateName});

  factory State.fromJson(Map<String, dynamic> parsedJson) {
    return State(
        stateId: parsedJson['state_id'], stateName: parsedJson['state_name']);
  }
}
