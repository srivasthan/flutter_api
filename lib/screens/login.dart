import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_json_parse/domain/user.dart';
import 'package:flutter_api_json_parse/utility/userPreferences.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String status, _fcmToken;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  // Initially password is obscure
  bool _isHidden = true;

  checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      status = (prefs.getString('cuscode') ?? '');
    });

    if (status != null && status.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/dashboard', (route) => false);
    }
  }

  // Toggles the password show status
  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  getToken() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      _fcmToken = await _fcm.getToken();
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
    checkLogin();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    var saveUser;

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

    var doLogin = () async {
      final form = formKey.currentState;

      var result = await Connectivity().checkConnectivity();
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        if (form.validate()) {
          form.save();

          final Map<String, dynamic> loginData = {
            'username': emailController.text,
            'password': passwordController.text,
            'device_token': _fcmToken,
            'device_type': 'Android'
          };

          showAlertDialog(context);

          final Response<Map<String, dynamic>> _result = await Dio().request(
              'customer_login/',
              queryParameters: <String, dynamic>{},
              options: RequestOptions(
                  method: 'POST',
                  headers: {'Content-Type': 'application/json'},
                  extra: <String, dynamic>{},
                  baseUrl: 'https://dev.kaspontech.com/djadmin/'),
              data: loginData);

          final value = _result.data;

          print(value);

          String responseCode = value['response']['response_code'];

          if (responseCode == "500") {
            Navigator.of(context, rootNavigator: true).pop();
            Fluttertoast.showToast(
                msg: value['response']['message'],
                timeInSecForIosWeb: 1,
                toastLength: Toast.LENGTH_SHORT);
          } else if (responseCode == "200") {
            User authUser = User(
              cusCode: value['response']['customer_details']['customer_code'],
              cusName: value['response']['customer_details']['customer_name'],
              email: value['response']['customer_details']['email_id'],
              phone: value['response']['customer_details']['contact_number'],
            );

            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('password', passwordController.text.toString());
            prefs.setString('cuscode',
                value['response']['customer_details']['customer_code']);
            prefs.setString(
                "email", value['response']['customer_details']['email_id']);
            prefs.setInt("country_id",
                value['response']['customer_details']['country_id']);
            prefs.setInt(
                "state_id", value['response']['customer_details']['state_id']);
            prefs.setInt(
                "city_id", value['response']['customer_details']['city_id']);
            prefs.setInt("location_id",
                value['response']['customer_details']['location_id']);
            prefs.setString("plotnumber",
                value['response']['customer_details']['plot_number']);
            prefs.setString(
                "street", value['response']['customer_details']['street']);
            prefs.setString(
                "landmark", value['response']['customer_details']['landmark']);
            prefs.setString("post_code",
                value['response']['customer_details']['post_code'].toString());
            prefs.setString("contact",
                value['response']['customer_details']['contact_number']);
            prefs.setString("alternativecontact",
                value['response']['customer_details']['alternate_number']);
            prefs.setString(
                "name", value['response']['customer_details']['customer_name']);

            UserPreferences().saveUser(authUser);

            saveUser = {
              'status': true,
              'message': 'Successful',
              'user': authUser
            };

            Fluttertoast.showToast(
                msg: value['response']['message'],
                timeInSecForIosWeb: 1,
                toastLength: Toast.LENGTH_SHORT);

            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          }
        } else {
          Flushbar(
            title: 'Invalid form',
            message: 'Please complete the form properly',
            duration: Duration(seconds: 3),
          ).show(context);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Connect to internet",
            timeInSecForIosWeb: 1,
            toastLength: Toast.LENGTH_SHORT);
      }
    };

    final forgotLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          child: Text("Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/forgotPassword');
          },
        ),
        FlatButton(
          padding: EdgeInsets.only(left: 0.0),
          child: Text("Sign up", style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/register');
          },
        ),
      ],
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "\u00a9 Kaspon Techworks Pvt Ltd. All rights reserved",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            )
          ],
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
                  Text("Email"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: validateEmail,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Password"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: _toggleVisibility,
                        icon: _isHidden
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                    obscureText: _isHidden,
                    controller: passwordController,
                    validator: (value) =>
                        value.isEmpty ? 'Please enter password' : null,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  longButtons('Login', doLogin),
                  SizedBox(
                    height: 8.0,
                  ),
                  forgotLabel,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 16.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: hintText == "Email" ? Icon(Icons.email) : Icon(Icons.lock),
        suffixIcon: hintText == "Password"
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: _isHidden
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              )
            : null,
      ),
      obscureText: hintText == "Password" ? _isHidden : false,
    );
  }
}
