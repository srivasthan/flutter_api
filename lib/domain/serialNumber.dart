class SerialNumberModel {
  int customerContractId;
  String modelNo;
  String serialNo;
  int contractTypeId;
  String contractType;
  int duration;

  SerialNumberModel(
      {this.customerContractId,
      this.modelNo,
      this.serialNo,
      this.contractTypeId,
      this.contractType,
      this.duration});
}
