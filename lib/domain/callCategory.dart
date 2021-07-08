class CallCategoryModel {
  int callCategoryId;
  String callCategory;

  CallCategoryModel({this.callCategoryId, this.callCategory});
}

class Serial {
  List<SerialNoPojos> serial;

  Serial({this.serial});

  factory Serial.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['data'] as List;
    print(list.runtimeType);
    List<SerialNoPojos> dataList = list.map((i) => SerialNoPojos.fromJson(i)).toList();

    return Serial(
        serial: dataList);
  }
}

class SerialNoPojos {
  String serialNo;

  SerialNoPojos({this.serialNo});

  factory SerialNoPojos.fromJson(Map<String, dynamic> json) {
    return SerialNoPojos(
      serialNo: json['serial_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'serial_no': this.serialNo};
  }
}
