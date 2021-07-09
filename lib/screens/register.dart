import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:connection_status_bar/connection_status_bar.dart';

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
  }

  getState(int countryId) async {
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
    }
  }

  getCity(int stateId) async {
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
    }
  }

  getLocation(int cityId) async {
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
    }
  }

  getProduct() async {
    ConnectionStatusBar();
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
  }

  getSubProduct(int productId) async {
    RestClient apiService = RestClient(dio.Dio());

    final response = await apiService.getSubProduct(productId);

    if (response.subProductEntity.responseCode == "200") {
      setState(() {
        //subProduct.clear();
        for (var i = 0; i < response.subProductEntity.datum.length; i++) {
          subProduct.add(new SubProductModel(
              productSubId: response.subProductEntity.datum[i].prouductSubId,
              productSubName:
                  response.subProductEntity.datum[i].productSubName));
        }

        Navigator.pop(context);
      });
    }
  }

  getAmc() async {
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
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
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
    bool isEmail = true, isMobile = true, isAlternative = true;
    final form = formKey.currentState;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    Future<void> checkEmailPresence() async {
      final Map<String, dynamic> data = {'email_id': _email.text};

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
          Navigator.of(context, rootNavigator: true).pop();
          Flushbar(
            title: "Error",
            message: "Email already exists",
            duration: Duration(seconds: 3),
          ).show(context);
          break;
      }

      return _msg;
    }

    Future<void> checkMobilePresence() async {
      final Map<String, dynamic> data = {'email_id': _modelNumber.text};

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
          Navigator.of(context, rootNavigator: true).pop();
          Flushbar(
            title: "Error",
            message: "Mobile Number Already Exists",
            duration: Duration(seconds: 3),
          ).show(context);
          break;
      }

      return _msg;
    }

    var loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Registering ... Please wait")
      ],
    );

    var doRegister = () {
      showAlertDialog(context);

      checkEmailPresence();
      checkMobilePresence();

      if (isEmail == false) {
        Flushbar(
          title: "Error",
          message: "Email Already Exists",
          duration: Duration(seconds: 3),
        ).show(context);
      } else if (isMobile == false) {
        Flushbar(
          title: "Error",
          message: "Mobile Number Already Exists",
          duration: Duration(seconds: 3),
        ).show(context);
      } else {
        if (form.validate()) {
          form.save();

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
        } else {
          Flushbar(
            title: 'Invalid form',
            message: 'Please complete the form properly',
            duration: Duration(seconds: 10),
          ).show(context);
        }
      }
    };

    return Scaffold(
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _mobile,
                  validator: (value) {
                    String _msg;
                    if (value.isEmpty) {
                      _msg = "Please enter mobile number";
                    } else if (value.length < 10) {
                      _msg = "mobile number should be 10 numbers";
                    } else if (!value.startsWith("6") &&
                        !value.startsWith("7") &&
                        !value.startsWith("8") &&
                        !value.startsWith("9")) {
                      _msg = "Contact Number Should Start from 6,7,8,9";
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _alternateMobile,
                  validator: (value) {
                    String _msg;
                    if (value.isEmpty) {
                      _msg = "Please enter mobile number";
                    } else if (value.length < 10) {
                      _msg = "mobile number should be 10 numbers";
                    } else if (!value.startsWith("6") &&
                        !value.startsWith("7") &&
                        !value.startsWith("8") &&
                        !value.startsWith("9")) {
                      _msg = "Contact Number Should Start from 6,7,8,9";
                    } else if (_alternateMobile.text == value) {
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
                SearchableDropdown.single(
                  isExpanded: true,
                  value: productModel,
                  hint: new Text("Select Product"),
                  displayClearIcon: false,
                  onChanged: (ProductModel data) {
                    setState(() {
                      showAlertDialog(context);
                      productModel = data;
                      _productId = productModel.productId;
                      subProduct.clear();
                      subProductModel = null;
                      getSubProduct(_productId);
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
                SearchableDropdown.single(
                  isExpanded: true,
                  value: countryModel,
                  hint: new Text("Select Country"),
                  displayClearIcon: false,
                  onChanged: (CountryModel data) {
                    setState(() {
                      countryModel = data;
                      _countryId = countryModel.countryId;
                      state.clear();
                      stateModel = null;
                      getState(_countryId);
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select country' : null,
                  items: country.map((CountryModel value) {
                    return DropdownMenuItem<CountryModel>(
                      value: value,
                      child: new Text(
                        value.countryName,
                        textAlign: TextAlign.center,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
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
                auth.loggedInStatus == Status.Authenticating
                    ? loading
                    : longButtons('Register', doRegister)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
