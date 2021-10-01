class TicketListResponseData {
  String ticketId;
  String product;
  String subProduct;
  String model;
  String serialNo;
  String technicainName;
  String technicianNumber;
  String raisedDateTime;
  String workType;
  String problemDesc;
  int statusCode;
  String statusName;

  TicketListResponseData({
    this.ticketId,
    this.product,
    this.subProduct,
    this.model,
    this.serialNo,
    this.technicainName,
    this.technicianNumber,
    this.raisedDateTime,
    this.workType,
    this.problemDesc,
    this.statusCode,
    this.statusName,
  });

  TicketListResponseData.fromJson(Map<String, dynamic> json) {
    ticketId = json["ticket_id"]?.toString();
    product = json["product"]?.toString();
    subProduct = json["sub_product"]?.toString();
    model = json["model"]?.toString();
    serialNo = json["serial_no"]?.toString();
    technicainName = json["technicain_name"]?.toString();
    technicianNumber = json["technician_number"]?.toString();
    raisedDateTime = json["raised_date_time"]?.toString();
    workType = json["work_type"]?.toString();
    problemDesc = json["problem_desc"]?.toString();
    statusCode = json["status_code"]?.toInt();
    statusName = json["status_name"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["ticket_id"] = ticketId;
    data["product"] = product;
    data["sub_product"] = subProduct;
    data["model"] = model;
    data["serial_no"] = serialNo;
    data["technicain_name"] = technicainName;
    data["technician_number"] = technicianNumber;
    data["raised_date_time"] = raisedDateTime;
    data["work_type"] = workType;
    data["problem_desc"] = problemDesc;
    data["status_code"] = statusCode;
    data["status_name"] = statusName;
    return data;
  }
}

class TicketListResponse {
  String responseCode;
  String token;
  List<TicketListResponseData> data;

  TicketListResponse({
    this.responseCode,
    this.token,
    this.data,
  });

  TicketListResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json["response_code"]?.toString();
    token = json["token"]?.toString();
    if (json["data"] != null) {
      final v = json["data"];
      final arr0 = <TicketListResponseData>[];
      v.forEach((v) {
        arr0.add(TicketListResponseData.fromJson(v));
      });
      this.data = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["response_code"] = responseCode;
    data["token"] = token;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v.forEach((v) {
        arr0.add(v.toJson());
      });
      data["data"] = arr0;
    }
    return data;
  }
}

class TicketList {
  TicketListResponse ticketListResponse;

  TicketList({
    this.ticketListResponse,
  });

  TicketList.fromJson(Map<String, dynamic> json) {
    ticketListResponse = (json["response"] != null)
        ? TicketListResponse.fromJson(json["response"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (ticketListResponse != null) {
      data["response"] = ticketListResponse.toJson();
    }
    return data;
  }
}
