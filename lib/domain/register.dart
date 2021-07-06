class Register {
  String cusCode;
  String cusName;
  String email;
  String phone;
  String alternateNumber;
  String plotNumber;
  String token;

  Register(
      {this.cusCode,
      this.cusName,
      this.email,
      this.phone,
      this.alternateNumber,
      this.plotNumber,
      this.token}); // now create converter

  factory Register.fromJson(Map<String, dynamic> responseData) {
    return Register(
      cusCode: responseData['customer_code'],
      cusName: responseData['customer_name'],
      email: responseData['email_id'],
      phone: responseData['contact_number'],
      alternateNumber: responseData['alternate_number'],
      token: responseData['token'],
      plotNumber: responseData['plot_number'],
    );
  }
}
