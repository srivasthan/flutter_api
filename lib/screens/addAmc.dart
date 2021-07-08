import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_api_json_parse/domain/amc.dart';
import 'package:flutter_api_json_parse/domain/callCategory.dart';
import 'package:flutter_api_json_parse/domain/city.dart';
import 'package:flutter_api_json_parse/domain/country.dart';
import 'package:flutter_api_json_parse/domain/location.dart';
import 'package:flutter_api_json_parse/domain/product.dart';
import 'package:flutter_api_json_parse/domain/state.dart';
import 'package:flutter_api_json_parse/domain/subProduct.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:flutter_api_json_parse/providers/auth_provider.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'package:connectivity/connectivity.dart';

class AddAmc extends StatefulWidget {
  @override
  _AddAmc createState() => _AddAmc();
}

class _AddAmc extends State<AddAmc> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();
  bool isValidate = true, serialRowVisible = false, itemsRowVisible = false;
  String _cusCode,
      _dummy,
      token,
      newToken,
      _testcountry,
      _cusName,
      _contact,
      _alternativecontact,
      _email;
  Map<String, dynamic> serialArray;
  var body, send;
  TextEditingController _date = new TextEditingController();
  TextEditingController _duration = new TextEditingController();
  TextEditingController _contractDurationDate = new TextEditingController();
  TextEditingController _modelNumber = new TextEditingController();
  TextEditingController _serialNumber = new TextEditingController();
  TextEditingController _invoiceNumber = new TextEditingController();
  TextEditingController _plotNumber = new TextEditingController();
  TextEditingController _street = new TextEditingController();
  TextEditingController _landMark = new TextEditingController();
  TextEditingController _postCode = new TextEditingController();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ProductModel> product = List();
  List<AmcModel> amc = List();
  List<CountryModel> country = List();
  List<StateModel> state = List();
  List<CityModel> city = List();
  List<LocationModel> location = List();
  List<CallCategoryModel> callCategoryList = List();
  List<String> countrytest = new List<String>();
  List<int> countryid = new List<int>();
  List<SubProductModel> subProduct = new List<SubProductModel>();
  List<String> serialNumberList = new List<String>();
  List<SerialNoPojos> serialNoPojosList = new List<SerialNoPojos>();
  CountryModel countryModel;
  StateModel stateModel;
  CityModel cityModel;
  LocationModel locationModel;
  ProductModel productModel;
  SubProductModel subProductModel;
  CallCategoryModel callCategoryModel;
  SerialNoPojos amcserial;
  AmcModel amcModel;
  bool _loading = true;
  var inputDate, contractStartDate;
  int _productId,
      _amcId,
      _countryId,
      _callCategoryId,
      _stateId,
      _cityId,
      _locationId,
      _contractDuration,
      _getAmount,
      _subProductId = -1;

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

  getCountry() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getCountry();

      if (response.countryEntity.responseCode == "200") {
        country = new List<CountryModel>();
        setState(() {
          for (var i = 0; i < response.countryEntity.datum.length; i++) {
            country.add(new CountryModel(
                countryId: response.countryEntity.datum[i].countryId,
                countryName: response.countryEntity.datum[i].countryName));
            countrytest.add(response.countryEntity.datum[i].countryName);
            countryid.add(response.countryEntity.datum[i].countryId);
          }

          _testcountry = "India";
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

  getState(int countryId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showAlertDialog(context);
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getState(countryId);

      if (response.stateEntity.responseCode == "200") {
        state = new List<StateModel>();
        setState(() {
          for (var i = 0; i < response.stateEntity.datum.length; i++) {
            state.add(new StateModel(
                stateId: response.stateEntity.datum[i].stateId,
                stateName: response.stateEntity.datum[i].stateName));
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

  getCity(int stateId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getCity(stateId);

      showAlertDialog(context);

      if (response.cityEntity.responseCode == "200") {
        city = new List<CityModel>();
        setState(() {
          for (var i = 0; i < response.cityEntity.datum.length; i++) {
            city.add(new CityModel(
                cityId: response.cityEntity.datum[i].cityId,
                cityName: response.cityEntity.datum[i].cityName));
          }
        });

        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  getLocation(int cityId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getLocation(cityId);

      showAlertDialog(context);

      if (response.locationEntity.responseCode == "200") {
        location = new List<LocationModel>();
        setState(() {
          for (var i = 0; i < response.locationEntity.datum.length; i++) {
            location.add(new LocationModel(
                locationId: response.locationEntity.datum[i].locationId,
                locationName: response.locationEntity.datum[i].locationName));
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

  getProduct() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getProduct();

      if (response.productEntity.responseCode == "200") {
        product = new List<ProductModel>();
        setState(() {
          for (var i = 0; i < response.productEntity.datum.length; i++) {
            product.add(new ProductModel(
                productId: response.productEntity.datum[i].prouductId,
                productName: response.productEntity.datum[i].productName));
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

  getAmc() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getAmcDetails();

      if (response.amcEntity.responseCode == "200") {
        amc = new List<AmcModel>();
        setState(() {
          for (var i = 0; i < response.amcEntity.datum.length; i++) {
            amc.add(new AmcModel(
                amcId: response.amcEntity.datum[i].amcId,
                duration: response.amcEntity.datum[i].duration,
                cost: response.amcEntity.datum[i].cost,
                amcName: response.amcEntity.datum[i].amcType));
          }
        });
        Navigator.of(context, rootNavigator: true).pop();
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
          firstDate: DateTime(2015, 8),
          lastDate: DateTime.now());
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

  Future<void> _selectContractDurationDate(BuildContext context) async {
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
          contractStartDate = formatter.format(selectedDate);
          _contractDurationDate.value =
              TextEditingValue(text: contractStartDate.toString());
        });
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  setDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cusCode = (prefs.getString('cuscode') ?? '');
      token = (prefs.getString('token') ?? '');
      _cusName = (prefs.getString('name') ?? '');
      _contact = (prefs.getString('contact') ?? '');
      _alternativecontact = (prefs.getString('alternativecontact') ?? '');
      _email = (prefs.getString('email') ?? '');
      _countryId = (prefs.getInt('country_id') ?? 0);
      _stateId = (prefs.getInt('state_id') ?? 0);
      _cityId = (prefs.getInt('city_id') ?? 0);
      _locationId = (prefs.getInt('location_id') ?? 0);
      _plotNumber.value =
          TextEditingValue(text: (prefs.getString('plotnumber') ?? ''));
      _street.value = TextEditingValue(text: (prefs.getString('street') ?? ''));
      _landMark.value =
          TextEditingValue(text: (prefs.getString('landmark') ?? ''));
      _postCode.value =
          TextEditingValue(text: (prefs.getString('post_code') ?? ''));
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlertDialog(context);
    });
    getCountry();
    getProduct();
    getAmc();
    getCall();
    setDetails();
  }

  @override
  Widget build(BuildContext context) {
    String _msg;
    bool isEmail = true, isMobile = true, isAlternative = true;
    final form = formKey.currentState;

    AuthProvider auth = Provider.of<AuthProvider>(context);

    Future<void> checkEmailPresence(String text) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final Map<String, dynamic> data = {'email_id': text};

        // done , now run app
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.emailVerify(data);

        switch (response.emailEntity.responseCode) {
          case "200":
            isEmail = true;
            break;

          case "400":

          case "500":
            isEmail = false;
            Flushbar(
              title: "Error",
              message: "Email already exists",
              duration: Duration(seconds: 3),
            ).show(context);
            break;
        }

        return _msg;
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    Future<void> checkMobilePresence(String text) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final Map<String, dynamic> data = {'email_id': text};

        // done , now run app
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.mobileVerify(data);

        switch (response.mobileEntity.responseCode) {
          case "200":
            isMobile = true;
            break;

          case "400":

          case "500":
            isMobile = false;
            Flushbar(
              title: "Error",
              message: "Mobile Number Already Exists",
              duration: Duration(seconds: 3),
            ).show(context);
            break;
        }

        return _msg;
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    getSubProduct(int productId) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.getSubProduct(productId);

        if (response.subProductEntity.responseCode == "200") {
          setState(() {
            for (var i = 0; i < response.subProductEntity.datum.length; i++) {
              subProduct.add(new SubProductModel(
                  productSubId:
                      response.subProductEntity.datum[i].prouductSubId,
                  productSubName:
                      response.subProductEntity.datum[i].productSubName));
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

    Future<void> checkSerialNo() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (_cusCode.isEmpty ||
            _productId == 0 ||
            _subProductId == 0 ||
            _modelNumber.text.isEmpty ||
            _serialNumber.text.isEmpty) {
          Fluttertoast.showToast(
              msg: "Details not valid",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              toastLength: Toast.LENGTH_SHORT);
        } else {
          showAlertDialog(context);
          final Map<String, dynamic> data = {
            'customer_code': _cusCode,
            'product_id': _productId,
            'product_sub_id': _subProductId,
            'model_no': _modelNumber.text,
            'serial_no': _serialNumber.text
          };

          // done , now run app
          RestClient apiService = RestClient(dio.Dio());

          final response = await apiService.validateSerialNo(data);

          switch (response.emailEntity.responseCode) {
            case "200":
              setState(() {
                serialNumberList.add(_serialNumber.text.trim());
                _serialNumber.text = "";
                _quantity.value =
                    TextEditingValue(text: serialNumberList.length.toString());
                _amount.value = TextEditingValue(
                    text: (serialNumberList.length * _getAmount).toString());
                Navigator.of(context, rootNavigator: true).pop();
              });
              break;

            case "500":
              Navigator.of(context, rootNavigator: true).pop();
              Fluttertoast.showToast(
                  msg: response.emailEntity.message,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);
          }
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

    var generateAmc = () async {
      if (form.validate()) {
        form.save();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          RestClient apiService = RestClient(dio.Dio());

          final combinedData = <Map<String, dynamic>>[];

          for (int i = 0; i < serialNumberList.length; i++) {
            String name = serialNumberList[i];
            Map<String, String> hi = {'serial_no': name};
            combinedData.add(hi);
          }

          final Map<String, dynamic> apiBodyData = {
            "alternate_number": _alternativecontact,
            "ammount": int.parse(_amount.text),
            "city_id": _cityId,
            "contact_number": _contact,
            "contract_period": _contractDuration,
            "contract_type": _amcId,
            "country_id": _countryId,
            "cust_preference_date": contractStartDate.toString(),
            "customer_code": _cusCode,
            "customer_name": _cusName,
            "email_id": _email,
            "invoice_id": _invoiceNumber.text,
            "landmark": _landMark.text,
            "location_id": _locationId,
            "model_no": _modelNumber.text,
            "plot_number": _plotNumber.text,
            "post_code": int.parse(_postCode.text),
            "priority": "P1",
            "product_id": _productId,
            "product_sub_id": _subProductId,
            "serial_array": combinedData,
            "state_id": _stateId,
            "street": _street.text
          };

          print(apiBodyData);

          showAlertDialog(context);

          final response = await apiService.addAMC(token, apiBodyData);

          if (response.responseEntity.responseCode == "200") {
            setState(() {
              newToken = response.responseEntity.token;
              prefs.setString('token', newToken.toString());

              Fluttertoast.showToast(
                  msg: response.responseEntity.message,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);

              Navigator.of(context, rootNavigator: true).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DashBoard(3)));
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
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    return Scaffold(
      appBar: AppBar(
        title: Text('Add AMC Contract'),
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
                  height: 15.0,
                ),
                Center(
                  child: Text(
                    "Customer Information",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter plot number' : null,
                  controller: _plotNumber,
                  decoration: InputDecoration(
                    labelText: 'Plot Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter street' : null,
                  controller: _street,
                  decoration: InputDecoration(
                    labelText: 'Street',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _landMark,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter landmark' : null,
                  decoration: InputDecoration(
                    labelText: 'Landmark',
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
                    child: SearchableDropdown.single(
                      underline: Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      isExpanded: true,
                      hint: "Select Country",
                      value: countryModel,
                      displayClearIcon: false,
                      onChanged: (CountryModel data) {
                        setState(() {
                          _testcountry = data.countryName;
                          countryModel = data;
                          _countryId = countryModel.countryId;

                          state.clear();
                          stateModel = null;
                          getState(_countryId);
                        });
                      },
                      items: country.map((CountryModel value) {
                        if (_countryId == 101) {
                          return DropdownMenuItem<CountryModel>(
                            value: value,
                            child: new Text(
                              value.countryName,
                              textAlign: TextAlign.center,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        } else {
                          return DropdownMenuItem<CountryModel>(
                            value: value,
                            child: new Text(
                              value.countryName,
                              textAlign: TextAlign.center,
                              style: new TextStyle(color: Colors.black),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('State'),
                SearchableDropdown.single(
                  isExpanded: true,
                  value: stateModel,
                  hint: new Text("Select State"),
                  displayClearIcon: false,
                  onChanged: (StateModel data) {
                    setState(() {
                      stateModel = data;
                      _stateId = stateModel.stateId;
                      city.clear();
                      cityModel = null;
                      getCity(_stateId);
                    });
                  },
                  items: state.map((StateModel value) {
                    return DropdownMenuItem<StateModel>(
                      value: value,
                      child: new Text(
                        value.stateName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('City'),
                SearchableDropdown.single(
                  isExpanded: true,
                  value: cityModel,
                  hint: new Text("Select City"),
                  displayClearIcon: false,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (CityModel data) {
                    setState(() {
                      cityModel = data;
                      _cityId = cityModel.cityId;
                      location.clear();
                      locationModel = null;
                      getLocation(_cityId);
                    });
                  },
                  items: city.map((CityModel value) {
                    return DropdownMenuItem<CityModel>(
                      value: value,
                      child: new Text(
                        value.cityName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Location'),
                SearchableDropdown.single(
                  isExpanded: true,
                  value: locationModel,
                  hint: new Text("Select Location"),
                  displayClearIcon: false,
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (LocationModel data) {
                    setState(() {
                      locationModel = data;
                      _locationId = locationModel.locationId;
                    });
                  },
                  items: location.map((LocationModel value) {
                    return DropdownMenuItem<LocationModel>(
                      value: value,
                      child: new Text(
                        value.locationName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  validator: validatePostcode,
                  controller: _postCode,
                  decoration: InputDecoration(
                    labelText: 'Postcode',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    "Contract Information",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Amc Type'),
                SearchableDropdown.single(
                  isExpanded: true,
                  value: amcModel,
                  hint: new Text("Select Amc Type"),
                  displayClearIcon: false,
                  onChanged: (AmcModel data) {
                    setState(() {
                      amcModel = data;
                      _amcId = amcModel.amcId;
                      _contractDuration = amcModel.duration;
                      _dummy = _contractDuration.toString() + "  months";
                      _duration.value = TextEditingValue(text: _dummy);
                      _getAmount = amcModel.cost.toInt();
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please amc type' : null,
                  items: amc.map((AmcModel value) {
                    return DropdownMenuItem<AmcModel>(
                      value: value,
                      child: new Text(
                        value.amcName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _duration,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter contract duration' : null,
                  autofocus: false,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    labelText: 'Contract Duration',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _contractDurationDate,
                  autofocus: false,
                  validator: (value) => value.isEmpty
                      ? 'Please select contract start date'
                      : null,
                  onTap: () {
                    _selectContractDurationDate(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Contract Start Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Text(
                    "Product Information",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Product'),
                SearchableDropdown.single(
                  isExpanded: true,
                  value: productModel,
                  hint: new Text("Select Product"),
                  displayClearIcon: false,
                  onChanged: (ProductModel data) {
                    setState(() {
                      productModel = data;
                      _productId = productModel.productId;

                      subProduct.clear();
                      subProductModel = null;
                      getSubProduct(_productId);
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
                SizedBox(
                  height: 20.0,
                ),
                Text('Sub Product'),
                SearchableDropdown.single(
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
                  hint: "Select Sub Product",
                  displayClearIcon: false,
                  onChanged: (SubProductModel data) {
                    setState(() {
                      subProductModel = data;
                      _subProductId = subProductModel.productSubId;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select subproduct' : null,
                  dialogBox: false,
                  isExpanded: true,
                  menuConstraints: BoxConstraints.tight(Size.fromHeight(250)),
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
                    child: SearchableDropdown.single(
                      underline: Padding(
                        padding: EdgeInsets.all(5),
                      ),
                      isExpanded: true,
                      hint: "Select Call Category",
                      value: callCategoryModel,
                      displayClearIcon: false,
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
                TextFormField(
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter invoice number' : null,
                  controller: _invoiceNumber,
                  decoration: InputDecoration(
                    labelText: 'Enter Invoice Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  controller: _date,
                  autofocus: false,
                  validator: (value) =>
                      value.isEmpty ? 'Please select purchase date' : null,
                  onTap: () {
                    _selectDate(context);
                    FocusScope.of(context).requestFocus(new FocusNode());
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Purchase Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        autofocus: false,
                        controller: _quantity,
                        enabled: false,
                        validator: (value) =>
                            value.isEmpty ? 'Please enter quantity' : null,
                        // controller: _invoiceNumber,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    new Expanded(
                        child: new GestureDetector(
                            onTap: () {
                              setState(() {
                                serialRowVisible = true;
                              });
                            },
                            child: new Text(
                              'Add',
                              style: new TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Visibility(
                  visible: serialRowVisible,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Expanded(
                        child: new TextFormField(
                          autofocus: false,
                          controller: _serialNumber,
                          decoration: InputDecoration(
                            labelText: 'Serial Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50.0,
                      ),
                      new GestureDetector(
                          onTap: () {
                            setState(() {
                              itemsRowVisible = true;
                              checkSerialNo();
                            });
                          },
                          child: new Text(
                            'Save',
                            style: new TextStyle(
                                color: Colors.blueAccent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                getTasListView(),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  autofocus: false,
                  controller: _amount,
                  validator: (value) =>
                      value.isEmpty ? 'Please enter amount' : null,
                  // controller: _invoiceNumber,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons('Generate', generateAmc)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTasListView() {
    return serialNumberList.isNotEmpty
        ? ListView.builder(
            itemCount: serialNumberList.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return new Column(children: [
                new Card(
                  child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: new Text(
                            serialNumberList[index],
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        new IconButton(
                          icon: new Icon(Icons.delete),
                          iconSize: 25,
                          onPressed: () {
                            setState(() {
                              serialNumberList.removeAt(index);
                              _quantity.value = TextEditingValue(
                                  text: serialNumberList.length.toString());
                              _amount.value = TextEditingValue(
                                  text: (serialNumberList.length * _getAmount)
                                      .toString());
                            });
                          },
                        )
                      ]),
                )
              ]);
            })
        : Center(
            child: Text(
              "Add Serial Number",
              style: TextStyle(fontSize: 15),
            ),
          );
  }
}
