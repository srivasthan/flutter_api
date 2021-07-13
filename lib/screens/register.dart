import 'package:connectivity/connectivity.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_json_parse/domain/amc.dart';
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

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();
  bool isValidate = true;
  String _storeMobileNumber, _dummy, dropdownValue;
  TextEditingController _date = new TextEditingController();
  TextEditingController _duration = new TextEditingController();
  TextEditingController _username = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _mobile = new TextEditingController();
  TextEditingController _alternateMobile = new TextEditingController();
  TextEditingController _modelNumber = new TextEditingController();
  TextEditingController _serialNumber = new TextEditingController();
  TextEditingController _invoiceNumber = new TextEditingController();
  TextEditingController _plotNumber = new TextEditingController();
  TextEditingController _street = new TextEditingController();
  TextEditingController _landMark = new TextEditingController();
  TextEditingController _postCode = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<ProductModel> product = List();
  List<AmcModel> amc = List();
  List<CountryModel> country = List();
  List<StateModel> state = List();
  List<CityModel> city = List();
  List<LocationModel> location = List();
  List<String> test = new List<String>();
  List<SubProductModel> subProduct = new List<SubProductModel>();
  CountryModel countryModel;
  StateModel stateModel;
  CityModel cityModel;
  LocationModel locationModel;
  ProductModel productModel;
  SubProductModel subProductModel;
  AmcModel amcModel;
  bool _loading = true;
  var inputDate;
  int _productId,
      _amcId,
      _countryId,
      _stateId,
      _cityId,
      _locationId,
      _contractDuration,
      _subProductId = -1;

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: const Text(
                    "FieldPro",
                    style: TextStyle(fontSize: 20),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const [
                        Text(
                          "Do you want to exit?",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () => {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop()
                                },
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/login', (route) => false);
                            },
                            padding: EdgeInsets.all(0.0),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            ))
                      ],
                    ),
                  ],
                )) ??
        false;
  }

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
          }
        });
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Connect to internet",
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
                amcName: response.amcEntity.datum[i].amcType));
          }
        });
        Navigator.of(context, rootNavigator: true).pop();
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Connect to internet",
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
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          inputDate = formatter.format(selectedDate);
          _date.value = TextEditingValue(text: inputDate.toString());
        });
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
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
  }

  @override
  Widget build(BuildContext context) {
    String _msg;
    bool isEmail = true, isMobile = true;
    final form = formKey.currentState;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    getSubProduct(int productId) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        showAlertDialog(context);
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
          });
          Navigator.of(context, rootNavigator: true).pop();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
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
          });
          Navigator.of(context, rootNavigator: true).pop();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    getCity(int stateId) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        showAlertDialog(context);
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.getCity(stateId);

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
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    getLocation(int cityId) async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        showAlertDialog(context);
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.getLocation(cityId);

        if (response.locationEntity.responseCode == "200") {
          location = new List<LocationModel>();
          setState(() {
            for (var i = 0; i < response.locationEntity.datum.length; i++) {
              location.add(new LocationModel(
                  locationId: response.locationEntity.datum[i].locationId,
                  locationName: response.locationEntity.datum[i].locationName));
            }
          });
          Navigator.of(context, rootNavigator: true).pop();
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    Future<void> checkEmailPresence() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final Map<String, dynamic> data = {'email_id': _email.text};

        // done , now run app
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.emailVerify(data);

        if (response.emailEntity.responseCode == "500") {
          isEmail = false;
          Navigator.of(context, rootNavigator: true).pop();
          Flushbar(
            title: "Error",
            message: "Email already exists",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    Future<void> checkMobilePresence() async {
      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        final Map<String, dynamic> data = {'contact_number': _mobile.text};

        // done , now run app
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.mobileVerify(data);

        if (response.mobileEntity.responseCode == "500") {
          isMobile = false;
          Navigator.of(context, rootNavigator: true).pop();
          Flushbar(
            title: "Error",
            message: "Mobile already exists",
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    var doRegister = () async {
      if (form.validate()) {
        form.save();

        showAlertDialog(context);

        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          checkEmailPresence();
          checkMobilePresence();

          if (isEmail == false) {
          } else if (isMobile == false) {
          } else {
            final Future<Map<String, dynamic>> respose = auth.register(
                _username.text,
                _email.text,
                _mobile.text,
                _alternateMobile.text,
                _productId,
                _subProductId,
                _modelNumber.text,
                _serialNumber.text,
                inputDate.toString(),
                _amcId,
                _contractDuration,
                _plotNumber.text,
                _street.text,
                _landMark.text,
                _countryId,
                _stateId,
                _cityId,
                _locationId,
                int.parse(_postCode.text),
                _invoiceNumber.text);

            auth.loggedInStatus = Status.Authenticating;
            auth.notifyListeners();

            respose.then((response) {
              if (response['status']) {
                Navigator.of(context, rootNavigator: true).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              }
            });
          }
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          Fluttertoast.showToast(
              msg: "Connect to internet",
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

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Registration'),
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
                    SizedBox(
                      height: 7.0,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      autofocus: false,
                      controller: _username,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter name' : null,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        String _msg;
                        RegExp regex = new RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
                        if (value.isEmpty) {
                          _msg = "Please enter email";
                        } else if (!regex.hasMatch(value)) {
                          _msg = "Please provide a valid email address";
                        }
                        return _msg;
                      },
                      controller: _email,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _mobile,
                      validator: (value) {
                        String _msg;
                        if (value.isEmpty) {
                          _msg = "Please enter mobile number";
                        } else if (!value.startsWith("6") &&
                            !value.startsWith("7") &&
                            !value.startsWith("8") &&
                            !value.startsWith("9")) {
                          _msg = "Contact Number Should Start from 6,7,8,9";
                        } else if (value.length < 10) {
                          _msg = "mobile number should be 10 numbers";
                        }

                        return _msg;
                      },
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _alternateMobile,
                      validator: (value) {
                        String _msg;
                        if (!value.startsWith("6") &&
                            !value.startsWith("7") &&
                            !value.startsWith("8") &&
                            !value.startsWith("9")) {
                          _msg = "Contact Number Should Start from 6,7,8,9";
                        } else if (value.length < 10) {
                          _msg = "mobile number should be 10 numbers";
                        } else if (_mobile.text == value) {
                          _msg = "Mobile and Alternate Mobile can't be same";
                        }

                        return _msg;
                      },
                      decoration: InputDecoration(
                        labelText: 'Alternate Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Product'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: product,
                        label: 'Select Product',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: product?.map((items) {
                              return items.productName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              productModel = data;
                              _productId = productModel.productId;

                              subProduct.clear();
                              subProductModel = null;
                              //  insideAlertDialog(context);
                              getSubProduct(_productId);
                            });
                          } else {
                            productModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Sub Product'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: subProduct,
                        label: 'Select Sub Product',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: subProduct?.map((items) {
                              return items.productSubName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              subProductModel = data;
                              _subProductId = subProductModel.productSubId;
                            });
                          } else {
                            subProductModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
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
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
                      validator: (value) =>
                          value.isEmpty ? 'Please enter serial number' : null,
                      controller: _serialNumber,
                      decoration: InputDecoration(
                        labelText: 'Serial Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
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
                    TextField(
                      controller: _date,
                      autofocus: false,
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
                    Text('Amc Type'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: amc,
                        label: 'Select AMC Type',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: amc?.map((items) {
                              return items.amcName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              amcModel = data;
                              _amcId = amcModel.amcId;
                              _contractDuration = amcModel.duration;
                              _dummy =
                                  _contractDuration.toString() + "  months";
                              _duration.value = TextEditingValue(text: _dummy);
                            });
                          } else {
                            amcModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _duration,
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
                      autofocus: false,
                      keyboardType: TextInputType.text,
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
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
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
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
                      validator: (value) =>
                          value.isEmpty ? 'Please enter landmark' : null,
                      controller: _landMark,
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Country'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: country,
                        label: 'Select Country',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: country?.map((items) {
                              return items.countryName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              countryModel = data;
                              _countryId = countryModel.countryId;

                              state.clear();
                              stateModel = null;
                              city.clear();
                              location.clear();
                              cityModel = null;
                              locationModel = null;
                              getState(_countryId);
                            });
                          } else {
                            countryModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('State'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: state,
                        label: 'Select State',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: state?.map((items) {
                              return items.stateName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              stateModel = data;
                              _stateId = stateModel.stateId;

                              city.clear();
                              location.clear();
                              cityModel = null;
                              locationModel = null;
                              getCity(_stateId);
                            });
                          } else {
                            stateModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('City'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: city,
                        label: 'Select City',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: city?.map((items) {
                              return items.cityName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              cityModel = data;
                              _cityId = cityModel.cityId;

                              location.clear();
                              locationModel = null;
                              getLocation(_cityId);
                            });
                          } else {
                            cityModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text('Location'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 60,
                      child: customSearchableDropDown(
                        items: location,
                        label: 'Select Location',
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            borderRadius: BorderRadius.circular(5)),
                        dropDownMenuItems: location?.map((items) {
                              return items.locationName;
                            })?.toList() ??
                            [],
                        onChanged: (data) {
                          if (data != null) {
                            setState(() {
                              locationModel = data;
                              _locationId = locationModel.locationId;
                            });
                          } else {
                            locationModel = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
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
                      child: Material(
                        //Wrap with Material
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        // elevation: 18.0,
                        color: Colors.lightBlue,
                        clipBehavior: Clip.antiAlias,
                        // Add This
                        child: MaterialButton(
                          minWidth: 200.0,
                          height: 35,
                          child: new Text('Register',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: doRegister,
                        ),
                      ),
                    ),
                    // auth.loggedInStatus == Status.Authenticating
                    //     ? loading
                    //     : longButtons('Register', doRegister)
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: _onBackPressed);
  }
}
