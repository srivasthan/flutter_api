import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class PasswordChange extends StatefulWidget {
  @override
  _PasswordChange createState() => _PasswordChange();
}

class _PasswordChange extends State<PasswordChange> {
  final formKey = GlobalKey<FormState>();
  String getEmail, _password;
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  // Initially password is obscure
  bool _isOldPasswordHidden = true,
      _isNewPasswordHidden = true,
      _isConfirmPasswordHidden = true;

  void _OldtoggleVisibility() {
    setState(() {
      _isOldPasswordHidden = !_isOldPasswordHidden;
    });
  }

  void _NewtoggleVisibility() {
    setState(() {
      _isNewPasswordHidden = !_isNewPasswordHidden;
    });
  }

  void _ConfirmtoggleVisibility() {
    setState(() {
      _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
    });
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

  setDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _password = (prefs.getString('password') ?? '');
    });
  }

  @override
  void initState() {
    super.initState();
    setDetails();
  }

  @override
  Widget build(BuildContext context) {
    var changePassword = () async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        var result = await Connectivity().checkConnectivity();
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          showAlertDialog(context);

          SharedPreferences prefs = await SharedPreferences.getInstance();
          setState(() {
            getEmail = (prefs.getString("email") ?? '');
          });

          final Map<String, dynamic> data = {
            'email': getEmail,
            'old_password': oldPasswordController.text,
            'new_password': passwordController.text,
            'confirm_password': confirmPasswordController.text
          };

          // done , now run app
          RestClient apiService = RestClient(dio.Dio());

          final response = await apiService.changePassword(data);

          switch (response.resetPasswordEntity.responseCode) {
            case "200":
              {
                Navigator.of(context, rootNavigator: true).pop();
                Fluttertoast.showToast(
                    msg: response.resetPasswordEntity.message,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1);
                prefs.setString(
                    'password', confirmPasswordController.text.toString());
                Navigator.pushReplacementNamed(context, '/profile');
                break;
              }
            case "400":

            case "500":
              {
                Navigator.of(context, rootNavigator: true).pop();
                Flushbar(
                  title: "Error",
                  message: response.resetPasswordEntity.message,
                  duration: Duration(seconds: 3),
                ).show(context);
                break;
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Change Password'),
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
                  Text("Old Password"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Old Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _OldtoggleVisibility,
                          icon: _isOldPasswordHidden
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: _isOldPasswordHidden,
                      controller: oldPasswordController,
                      validator: (value) {
                        String _msg;
                        if (oldPasswordController.text.isEmpty) {
                          _msg = "Please Enter Old Password";
                        } else if (oldPasswordController.text.toString() !=
                            _password) {
                          _msg = "Old Password didn't match";
                        }
                        return _msg;
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("New Password"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                    obscureText: _isNewPasswordHidden,
                    keyboardType: TextInputType.visiblePassword,
                    controller: passwordController,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: IconButton(
                        onPressed: _NewtoggleVisibility,
                        icon: _isNewPasswordHidden
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                    ),
                  ),
                  new FlutterPwValidator(
                    controller: passwordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    width: 400,
                    height: 110,
                    onSuccess: () {
                      print("Matched");
                      Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("Password is matched")));
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text("Confirm Password"),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 16.0,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _ConfirmtoggleVisibility,
                          icon: _isConfirmPasswordHidden
                              ? Icon(Icons.visibility_off)
                              : Icon(Icons.visibility),
                        ),
                      ),
                      obscureText: _isConfirmPasswordHidden,
                      controller: confirmPasswordController,
                      validator: (value) {
                        String _msg;
                        if (passwordController.text.isEmpty) {
                          _msg = "Please Enter Confirm Password";
                        } else if (passwordController.text.toString() !=
                            confirmPasswordController.text.toString()) {
                          _msg = "Password and Confirm Password didn't match";
                        }
                        return _msg;
                      }),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Password must Contain:",
                          style: TextStyle(fontSize: 15)),
                      Text("Your password must be atleast 6 characters",
                          style: TextStyle(fontSize: 15)),
                      Text("Atleast one number (0-9)",
                          style: TextStyle(fontSize: 15)),
                      Text("Atleast one special character",
                          style: TextStyle(fontSize: 15)),
                      Text("Atleast one upper case letter(A-Z)",
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  longButtons('Change Password', changePassword),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
