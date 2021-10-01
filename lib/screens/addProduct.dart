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
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'package:connectivity/connectivity.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProduct createState() => _AddProduct();
}

class _AddProduct extends State<AddProduct> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  final formKey = GlobalKey<FormState>();
  bool isValidate = true, isVisible = false;
  String _cusCode, _dummy, token, newToken;
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
  DateTime selectedDate = DateTime.now();
  DateTime selectedPurchaseDate = DateTime.now();
  List<ProductModel> product = new List<ProductModel>();
  List<AmcModel> amc = new List<AmcModel>();
  List<CountryModel> country = new List<CountryModel>();
  List<StateModel> state = new List<StateModel>();
  List<CityModel> city = new List<CityModel>();
  List<LocationModel> location = new List<LocationModel>();
  List<SubProductModel> subProduct = new List<SubProductModel>();
  CountryModel countryModel;
  StateModel stateModel;
  CityModel cityModel;
  LocationModel locationModel;
  ProductModel productModel;
  SubProductModel subProductModel;
  AmcModel amcModel;
  var inputDate, contractStartDate;
  int _productId,
      _amcId,
      _countryId,
      _initialCountryId,
      _initialStateId,
      _initialCityId,
      _initialLocationId,
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
                          "Do you want to Exit?",
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () => {Navigator.pop(context)},
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context,
                                  true); // It worked for me instead of above line
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DashBoard(3)));
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
        setState(() {
          for (var i = 0; i < response.countryEntity.datum.length; i++) {
            if (response.countryEntity.datum[i].countryId == _countryId) {
              _initialCountryId = i;
            }
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

  getState(int countryId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showAlertDialog(context);
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getState(countryId);

      if (response.stateEntity.responseCode == "200") {
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
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  initialState(int countryId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getState(countryId);

      if (response.stateEntity.responseCode == "200") {
        setState(() {
          for (var i = 0; i < response.stateEntity.datum.length; i++) {
            if (response.stateEntity.datum[i].stateId == _stateId) {
              _initialStateId = i;
            }
            state.add(new StateModel(
                stateId: response.stateEntity.datum[i].stateId,
                stateName: response.stateEntity.datum[i].stateName));
          }
        });
      }
    } else {
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
        setState(() {
          for (var i = 0; i < response.cityEntity.datum.length; i++) {
            city.add(new CityModel(
                cityId: response.cityEntity.datum[i].cityId,
                cityName: response.cityEntity.datum[i].cityName));
          }
          Navigator.of(context, rootNavigator: true).pop();
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  initialCity(int stateId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getCity(stateId);

      if (response.cityEntity.responseCode == "200") {
        setState(() {
          for (var i = 0; i < response.cityEntity.datum.length; i++) {
            if (response.cityEntity.datum[i].cityId == _cityId) {
              _initialCityId = i;
            }
            city.add(new CityModel(
                cityId: response.cityEntity.datum[i].cityId,
                cityName: response.cityEntity.datum[i].cityName));
          }
        });
      }
    } else {
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
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  initialLocation(int cityId) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getLocation(cityId);

      if (response.locationEntity.responseCode == "200") {
        setState(() {
          for (var i = 0; i < response.locationEntity.datum.length; i++) {
            if (response.locationEntity.datum[i].locationId == _locationId) {
              _initialLocationId = i;
            }
            location.add(new LocationModel(
                locationId: response.locationEntity.datum[i].locationId,
                locationName: response.locationEntity.datum[i].locationName));
          }
        });
        Navigator.of(context, rootNavigator: true).pop();
        isVisible = true;
      }
    } else {
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
        setState(() {
          for (var i = 0; i < response.amcEntity.datum.length; i++) {
            amc.add(new AmcModel(
                amcId: response.amcEntity.datum[i].amcId,
                duration: response.amcEntity.datum[i].duration,
                amcName: response.amcEntity.datum[i].amcType));
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
          initialDate: selectedPurchaseDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 14)));
      if (picked != null && picked != selectedPurchaseDate)
        setState(() {
          selectedPurchaseDate = picked;
          final DateFormat formatter = DateFormat('yyyy-MM-dd');
          contractStartDate = formatter.format(selectedPurchaseDate);
          _contractDurationDate.value =
              TextEditingValue(text: contractStartDate.toString());
        });
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  setDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cusCode = (prefs.getString('cuscode') ?? '');
      token = (prefs.getString('token') ?? '');
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
      initialState(_countryId);
      initialCity(_stateId);
      initialLocation(_cityId);
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlertDialog(context);
    });
    setDetails();
    getCountry();
    getProduct();
    getAmc();
  }

  @override
  Widget build(BuildContext context) {
    final form = formKey.currentState;
    bool isSerialExists = true;

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
            Navigator.of(context, rootNavigator: true).pop();
          });
        }
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
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
              timeInSecForIosWeb: 1,
              toastLength: Toast.LENGTH_SHORT);
        } else {
          final Map<String, dynamic> data = {
            'customer_code': _cusCode,
            'product_id': _productId,
            'product_sub_id': _subProductId,
            'model_no': _modelNumber.text,
            'serial_no': _serialNumber.text
          };

          print(data);

          // done , now run app
          RestClient apiService = RestClient(dio.Dio());

          final response = await apiService.validateSerialNo(data);

          if (response.emailEntity.responseCode == "500") {
            setState(() {
              isSerialExists = false;
              _serialNumber.text = "";
              Navigator.of(context, rootNavigator: true).pop();
              Fluttertoast.showToast(
                  msg:
                      "Serial Number already exists. Please enter different serial number",
                  timeInSecForIosWeb: 1,
                  toastLength: Toast.LENGTH_SHORT);
            });
          } else {
            setState(() {
              isSerialExists = true;
            });
          }
        }
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    }

    var addProduct = () async {
      if (form.validate()) {
        form.save();

        SharedPreferences prefs = await SharedPreferences.getInstance();

        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          showAlertDialog(context);
          checkSerialNo();

          if (isSerialExists == false) {
          } else {
            RestClient apiService = RestClient(dio.Dio());

            final Map<String, dynamic> apiBodyData = {
              'customer_code': _cusCode.toString(),
              'product_id': _productId,
              'product_sub_id': _subProductId,
              'model_no': _modelNumber.text,
              'serial_no': _serialNumber.text,
              'contract_type_id': _amcId,
              'contract_duration': _contractDuration,
              'start_date': contractStartDate.toString(),
              'plot_number': _plotNumber.text,
              'street': _street.text,
              'post_code': _postCode.text,
              'landmark': _landMark.text,
              'country_id': _countryId.toString(),
              'state_id': _stateId.toString(),
              'city_id': _cityId.toString(),
              'location_id': _locationId.toString(),
              'purchase_date': inputDate.toString(),
              'invoice_id': _invoiceNumber.text
            };

            final response = await apiService.addProduct(token, apiBodyData);

            if (response.responseEntity.responseCode == "200") {
              setState(() {
                newToken = response.responseEntity.token;
                prefs.setString('token', newToken.toString());

                Fluttertoast.showToast(
                    msg: response.responseEntity.message,
                    timeInSecForIosWeb: 1,
                    toastLength: Toast.LENGTH_SHORT);

                Navigator.pop(context, true);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DashBoard(3)));
              });
            }
          }
        } else {
          Fluttertoast.showToast(
              msg: "Connect to internet",
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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios),
            onPressed: () => _onBackPressed(),
          ),
          title: Text('Add Product'),
        ),
        body: Visibility(
          visible: isVisible,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
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
                      keyboardType: TextInputType.text,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter plot number' : null,
                      controller: _plotNumber,
                      decoration: InputDecoration(
                        labelText: 'Plot Number',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Street',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: _landMark,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))
                      ],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value.isEmpty ? 'Please enter landmark' : null,
                      decoration: InputDecoration(
                        labelText: 'Landmark',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      height: 48,
                      child: customSearchableDropDown(
                        items: country,
                        initialIndex: _initialCountryId,
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
                              _initialCountryId = country.indexOf(data);

                              state.clear();
                              stateModel = null;
                              city.clear();
                              location.clear();
                              cityModel = null;
                              locationModel = null;
                              getState(_countryId);
                            });
                          } else {
                            _initialCountryId = null;
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
                      height: 48,
                      child: customSearchableDropDown(
                        items: state,
                        initialIndex: _initialStateId,
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
                              _initialStateId = state.indexOf(data);

                              city.clear();
                              location.clear();
                              cityModel = null;
                              locationModel = null;
                              getCity(_stateId);
                            });
                          } else {
                            _initialStateId = null;
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
                      height: 48,
                      child: customSearchableDropDown(
                        items: city,
                        label: 'Select City',
                        initialIndex: _initialCityId,
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
                              _initialCityId = city.indexOf(data);

                              location.clear();
                              locationModel = null;
                              getLocation(_cityId);
                            });
                          } else {
                            _initialCityId = null;
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
                      height: 48,
                      child: customSearchableDropDown(
                        items: location,
                        initialIndex: _initialLocationId,
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
                              _initialLocationId = location.indexOf(data);
                            });
                          } else {
                            _initialLocationId = null;
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      validator: validatePostcode,
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _postCode,
                      decoration: InputDecoration(
                        labelText: 'Postcode',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 48,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => value.isEmpty
                          ? 'Please enter contract duration'
                          : null,
                      autofocus: false,
                      onTap: () {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                        labelText: 'Contract Duration',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _contractDurationDate,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 48,
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
                      height: 48,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Model Number',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Enter Invoice Number',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _date,
                      autofocus: false,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                          value.isEmpty ? 'Please select purchase date' : null,
                      onTap: () {
                        _selectDate(context);
                        FocusScope.of(context).requestFocus(new FocusNode());
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Purchase Date',
                        contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    longButtons('Add Product', addProduct)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
