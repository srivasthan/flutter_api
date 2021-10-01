class TicketListModel {
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

  TicketListModel({
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
}
