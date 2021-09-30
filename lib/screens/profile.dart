import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_api_json_parse/screens/passwordChange.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<_ProfileState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var stringValue;
  String token,
      cusCode,
      getName,
      getEmail,
      email,
      getMobile,
      getToken,
      getProfileResponseToken;

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
                            onPressed: () => {Navigator.pop(context)},
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/dashboard', (route) => false);
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

  Future<bool> logout() {
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
                            onPressed: () => {Navigator.pop(context)},
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop();
                              showAlertDialog(context);
                              customerLogout();
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

  customerLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = (prefs.getString('email') ?? '');

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.logoutCustomer(email);

      if (response.emailEntity.responseCode == "200") {
        Navigator.of(context, rootNavigator: true).pop();
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();
        Fluttertoast.showToast(
            msg: response.emailEntity.message,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1);
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Fluttertoast.showToast(
          msg: "Connect to internet",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  getCustomerToken(String cusCode) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final Map<String, dynamic> loginData = {'customer_code': cusCode};

      final response = await apiService.postTokenActivity(loginData);

      if (response.tokenEntity.responseCode == "200") {
        setState(() {
          getToken = response.tokenEntity.data;
          getFinalProfile(getToken, cusCode);
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

  getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringValue = (prefs.getString('cuscode') ?? '');
    });

    getCustomerToken(stringValue);
  }

  getFinalProfile(String token, String cuscode) async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getProfile(token, cuscode);

      if (response.profileEntity.responseCode == "200") {
        setState(() {
          getProfileResponseToken = response.profileEntity.token;
          getName = response.profileEntity.profileSaveEntity.cusName;
          getEmail = response.profileEntity.profileSaveEntity.email;
          getMobile = response.profileEntity.profileSaveEntity.phone;
        });

        nameController.value = TextEditingValue(text: getName.toString());
        emailController.value = TextEditingValue(text: getEmail.toString());
        mobileController.value = TextEditingValue(text: getMobile.toString());

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

  changePassword() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      final Map<String, dynamic> loginData = {
        'customer_code': stringValue,
        'customer_name': nameController.text,
        'email_id': emailController.text,
        'contact_number': mobileController.text,
        'alternate_number': ''
      };

      RestClient apiService = RestClient(dio.Dio());

      final response =
          await apiService.editProfile(getProfileResponseToken, loginData);

      if (response.responseEntity.responseCode == "200") {
        setState(() {
          showAlertDialog(context);
          Fluttertoast.showToast(
              msg: response.responseEntity.message,
              timeInSecForIosWeb: 1,
              toastLength: Toast.LENGTH_SHORT);
          getProfileDetails();
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlertDialog(context);
    });
    getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back_ios),
              onPressed: () => _onBackPressed(),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  logout();
                },
                child: Icon(
                  Icons.logout,
                  size: 35,
                ),
                shape:
                    CircleBorder(side: BorderSide(color: Colors.transparent)),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: Text(
                        "Customer Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.name,
                      validator: (value) =>
                          value.isEmpty ? "Please enter " : null,
                      controller: nameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: buildInputDecoration(
                          'Enter Name', Icons.account_circle_rounded),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration:
                          buildInputDecoration('Enter Email', Icons.email),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      keyboardType: TextInputType.number,
                      controller: mobileController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: validateMobile,
                      decoration:
                          buildInputDecoration('Enter Mobile', Icons.phone),
                    ),
                    SizedBox(
                      height: 30,
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
                          onPressed: () {
                            _navigateToNextScreen(context);
                          },
                          child: new Text('Change Password',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
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
                          child: new Text('Update Profile',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: changePassword,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PasswordChange()));
  }
}
