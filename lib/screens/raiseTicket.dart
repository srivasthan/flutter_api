import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_api_json_parse/domain/callCategory.dart';
import 'package:flutter_api_json_parse/domain/product.dart';
import 'package:flutter_api_json_parse/domain/serialNumber.dart';
import 'package:flutter_api_json_parse/domain/subProduct.dart';
import 'package:flutter_api_json_parse/domain/workTYpe.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:flutter_api_json_parse/providers/auth_provider.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

class RaiseTicketStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaiseTicket(
      onInit: () {
        _getThingsOnStartup().then((value) {
          print('Async done');
        });
      },
      child: Container(),
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }
}

class RaiseTicket extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const RaiseTicket({@required this.onInit, @required this.child});

  @override
  _RaiseTicket createState() => _RaiseTicket();
}

class _RaiseTicket extends State<RaiseTicket> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();
  bool isValidate = true, serialRowVisible = false, itemsRowVisible = false;
  String _cusCode,
      _dummy,
      token,
      _testcountry,
      _serialNumber,
      _cusName,
      _contact,
      _alternativecontact,
      encImageBase64 = "",
      _email;
  final String base64Format = "data:image/png;base64,";
  Map<String, dynamic> serialArray;
  var body, send;
  bool imageVisible = false;
  TextEditingController _date = new TextEditingController();
  TextEditingController _modelNumber = new TextEditingController();
  TextEditingController _contractType = new TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _description = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String _hour, _minute, _time;
  List<ProductModel> product = List();
  List<CallCategoryModel> callCategoryList = List();
  List<WorkModel> workTypeList = List();
  List<SerialNumberModel> serialList = List();
  List<SubProductModel> subProduct = new List<SubProductModel>();
  ProductModel productModel;
  SubProductModel subProductModel;
  CallCategoryModel callCategoryModel;
  WorkModel workModel;
  SerialNumberModel serialNumberModel;
  File imageResized, _photo;
  var image;
  var inputDate, inputTime;
  int _productId,
      _charLength = 0,
      _callCategoryId,
      _workTypeId,
      _customerContractId,
      _contractTypeId,
      _subProductId;

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getProduct() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getUProduct(token, _cusCode);

      if (response.uproductEntity.responseCode == "200") {
        product = new List<ProductModel>();
        setState(() {
          prefs.setString('token', response.uproductEntity.token);
          for (var i = 0; i < response.uproductEntity.datum.length; i++) {
            product.add(new ProductModel(
                productId: response.uproductEntity.datum[i].prouductId,
                productName: response.uproductEntity.datum[i].productName));
          }
        });
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  getWork() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getWorkType();

      if (response.workEntity.responseCode == "200") {
        callCategoryList = new List<CallCategoryModel>();
        setState(() {
          for (var i = 0; i < response.workEntity.datum.length; i++) {
            workTypeList.add(new WorkModel(
                workTypeId: response.workEntity.datum[i].workTypeId,
                workType: response.workEntity.datum[i].workType));
          }
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 14)));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          inputDate = formatter.format(selectedDate);
          _date.value = TextEditingValue(text: inputDate.toString());
        });
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (picked != null)
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ' : ' + _minute;
          _timeController.text = DateFormat.jm()
              .format(DateFormat("hh:mm").parse("$_hour:$_minute"));
        });
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  picker() async {
    var photo = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    imageResized = await FlutterNativeImage.compressImage(photo.path,
        quality: 100, targetWidth: 120, targetHeight: 120);

    if (photo != null) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        image = photo;

        List<int> imageBytes = imageResized.readAsBytesSync();
        encImageBase64 = base64Encode(imageBytes);
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  galleryPicker() async {
    var photo = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    if (photo != null) {
      Navigator.of(context, rootNavigator: true).pop();
      image = photo;
      setState(() {
        final bytes = File(image.path).readAsBytesSync();
        encImageBase64 = base64Encode(bytes);
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  setDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cusCode = (prefs.getString('cuscode') ?? '');
      token = (prefs.getString('token') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlertDialog(context);
    });
    getProduct();
    getWork();
    setDetails();
  }

  @override
  Widget build(BuildContext context) {
    final form = formKey.currentState;

    AuthProvider auth = Provider.of<AuthProvider>(context);

    getCall() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.getCallCategory();

        if (response.callCategoryEntity.responseCode == "200") {
          callCategoryList = new List<CallCategoryModel>();
          setState(() {
            for (var i = 0; i < response.callCategoryEntity.datum.length; i++) {
              callCategoryList.add(new CallCategoryModel(
                  callCategoryId:
                      response.callCategoryEntity.datum[i].callCategoryId,
                  callCategory:
                      response.callCategoryEntity.datum[i].callCategory));
            }
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    getSubProduct() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        token = (prefs.getString('token') ?? '');

        RestClient apiService = RestClient(dio.Dio());

        final response =
            await apiService.getUSubProduct(token, _cusCode, _productId);

        if (response.uSubProductEntity.responseCode == "200") {
          subProduct = new List<SubProductModel>();
          setState(() {
            prefs.setString('token', response.uSubProductEntity.token);
            for (var i = 0; i < response.uSubProductEntity.datum.length; i++) {
              subProduct.add(new SubProductModel(
                  productSubId:
                      response.uSubProductEntity.datum[i].prouductSubId,
                  productSubName:
                      response.uSubProductEntity.datum[i].productSubName));
            }
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    getSerial() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        token = (prefs.getString('token') ?? '');

        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.getSerialNumber(
            token, _cusCode, _productId, _subProductId);

        if (response.serialNumberEntity.responseCode == "200") {
          serialList = new List<SerialNumberModel>();
          setState(() {
            prefs.setString('token', response.serialNumberEntity.token);
            for (var i = 0; i < response.serialNumberEntity.datum.length; i++) {
              serialList.add(new SerialNumberModel(
                  serialNo: response.serialNumberEntity.datum[i].serialNo,
                  modelNo: response.serialNumberEntity.datum[i].modelNo,
                  customerContractId:
                      response.serialNumberEntity.datum[i].customerContractId,
                  contractTypeId:
                      response.serialNumberEntity.datum[i].contractTypeId,
                  contractType:
                      response.serialNumberEntity.datum[i].contractType));
            }
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var raiseTicket = () async {
      if (form.validate()) {
        form.save();

        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          token = (prefs.getString('token') ?? '');

          RestClient apiService = RestClient(dio.Dio());

          final Map<String, dynamic> apiBodyData = {
            "customer_code": _cusCode,
            "customer_contract_id": _customerContractId,
            "product_id": _productId,
            "product_sub_id": _subProductId,
            "model_no": _modelNumber.text,
            "serial_no": _serialNumber,
            "call_category_id": _callCategoryId,
            "cust_preference_date": inputDate.toString(),
            "contract_type_id": _contractTypeId,
            "work_type_id": _workTypeId,
            "problem_desc": _description.text,
            "image": base64Format + encImageBase64,
            "priority": "P1"
          };

          print(apiBodyData);

          showAlertDialog(context);

          final response = await apiService.raiseTicket(token, apiBodyData);

          if (response.raiseTicketEntity.responseCode == "200") {
            setState(() {
              Fluttertoast.showToast(
                  msg: response.raiseTicketEntity.message,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.of(context, rootNavigator: true).pop();
            });
          } else if (response.raiseTicketEntity.responseCode == "500") {
            setState(() {
              Fluttertoast.showToast(
                  msg: response.raiseTicketEntity.message,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.of(context, rootNavigator: true).pop();
            });
          } else if (response.raiseTicketEntity.responseCode == "400") {
            setState(() {
              Fluttertoast.showToast(
                  msg: response.raiseTicketEntity.message,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);
              Navigator.of(context, rootNavigator: true).pop();
            });
          }
        } else {
          Fluttertoast.showToast(
              msg: "Connect to internet",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              toastLength: Toast.LENGTH_SHORT);
        }
      } else {
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 3),
        ).show(context);
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Raise Ticket'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    child: DropdownButtonFormField<ProductModel>(
                      isExpanded: true,
                      value: productModel,
                      hint: new Text("Select Product"),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      onChanged: (ProductModel data) {
                        setState(() {
                          productModel = data;
                          _productId = productModel.productId;

                          subProduct.clear();
                          subProductModel = null;
                          getSubProduct();
                          showAlertDialog(context);
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select product' : null,
                      items: product.map((ProductModel value) {
                        return DropdownMenuItem<ProductModel>(
                          value: value,
                          child: new Text(
                            value.productName,
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    child: DropdownButtonFormField(
                      hint: new Text("Select Sub Product"),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      items: subProduct.map((SubProductModel value) {
                        return DropdownMenuItem<SubProductModel>(
                          value: value,
                          child: new Text(
                            value.productSubName,
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                      value: subProductModel,
                      onChanged: (SubProductModel data) {
                        setState(() {
                          subProductModel = data;
                          _subProductId = subProductModel.productSubId;

                          serialList.clear();
                          serialNumberModel = null;
                          getSerial();
                          showAlertDialog(context);
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select subproduct' : null,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: EdgeInsets.all(5),
                    ),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      hint: new Text("Select Serial Number"),
                      value: serialNumberModel,
                      validator: (value) =>
                          value == null ? 'Please select serial number' : null,
                      onChanged: (SerialNumberModel data) {
                        setState(() {
                          serialNumberModel = data;
                          _serialNumber = serialNumberModel.serialNo;
                          _customerContractId =
                              serialNumberModel.customerContractId;
                          _contractTypeId = serialNumberModel.contractTypeId;

                          //setting contract type and model number
                          _contractType.value = TextEditingValue(
                              text: serialNumberModel.contractType);
                          _modelNumber.value =
                              TextEditingValue(text: serialNumberModel.modelNo);
                        });
                      },
                      items: serialList.map((SerialNumberModel value) {
                        return DropdownMenuItem<SerialNumberModel>(
                          value: value,
                          child: new Text(
                            value.serialNo,
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter contract type' : null,
                  controller: _contractType,
                  decoration: InputDecoration(
                    labelText: 'Contract type',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please model number' : null,
                  controller: _modelNumber,
                  decoration: InputDecoration(
                    labelText: 'Model Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: EdgeInsets.all(2),
                    ),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      hint: Text("Select Work Type"),
                      validator: (value) =>
                          value == null ? 'Please select work type' : null,
                      value: workModel,
                      onChanged: (WorkModel data) {
                        setState(() {
                          workModel = data;
                          _workTypeId = workModel.workTypeId;
                          showAlertDialog(context);
                          getCall();
                        });
                      },
                      items: workTypeList.map((WorkModel value) {
                        return DropdownMenuItem<WorkModel>(
                          value: value,
                          child: new Text(
                            value.workType,
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      contentPadding: EdgeInsets.all(2),
                    ),
                    child: DropdownButtonFormField(
                      isExpanded: true,
                      hint: Text("Call Category"),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        contentPadding: EdgeInsets.all(5),
                      ),
                      value: callCategoryModel,
                      validator: (value) =>
                          value == null ? 'Please select subproduct' : null,
                      onChanged: (CallCategoryModel data) {
                        setState(() {
                          callCategoryModel = data;
                          _callCategoryId = callCategoryModel.callCategoryId;
                        });
                      },
                      items: callCategoryList.map((CallCategoryModel value) {
                        return DropdownMenuItem<CallCategoryModel>(
                          value: value,
                          child: new Text(
                            value.callCategory,
                            textAlign: TextAlign.center,
                            style: new TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _description,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  textAlignVertical: TextAlignVertical.top,
                  onChanged: (value) {
                    setState(() {
                      _charLength = value.length;
                    });
                  },
                  validator: (value) =>
                      value.isEmpty ? 'Please enter description' : null,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(_charLength.toString() + "/250"),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    new Expanded(
                      child: Visibility(
                        visible: imageVisible,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Stack(
                                children: <Widget>[
                                  new Container(
                                    height: 70,
                                    width: 70,
                                    child: new Center(
                                      child: image == null
                                          ? new Text('No Image to Show ')
                                          : new Image.file(image),
                                    ),
                                  ),
                                  Positioned(
                                    top: -17,
                                    right: 45,
                                    child: GestureDetector(
                                      onTap: () {
                                        print('delete image from List');
                                        setState(() {
                                          print('set new state of images');
                                        });
                                      },
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            imageVisible = false;
                                            encImageBase64 = "";
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/images/close_icon.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    new Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Material(
                            //Wrap with Material
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            // elevation: 18.0,
                            color: Colors.lightBlue,
                            clipBehavior: Clip.antiAlias,
                            // Add This
                            child: MaterialButton(
                              child: new Text('Attach Image',
                                  style: new TextStyle(
                                      fontSize: 16.0, color: Colors.white)),
                              onPressed: () {
                                _showSelectionDialog(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _date,
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please select date' : null,
                  onTap: () {
                    _selectDate(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _timeController,
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please select time' : null,
                  onTap: () {
                    _selectTime(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Time',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time_outlined),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons('Raise Ticket', raiseTicket)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose your action"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        setState(() {
                          imageVisible = true;
                          galleryPicker();
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        setState(() {
                          imageVisible = true;
                          picker();
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Cancel"),
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                ),
              ));
        });
  }
}
