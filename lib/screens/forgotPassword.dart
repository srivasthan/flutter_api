import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flushbar/flushbar.dart';
import 'package:dio/dio.dart' as dio;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController lastNameController = TextEditingController();

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: const Text(
                    "Field Pro",
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
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/login');
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.all(0.0),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () => {Navigator.pop(context)},
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            ))
                      ],
                    ),
                  ],
                )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    String _errormsg;

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

    String validatePassword(String value) {
      if (!(value.length > 5) && value.isNotEmpty) {
        return "Password should contain more than 5 characters";
      }
      return null;
    }

    Future<void> checkEmailPresence() async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();

        showAlertDialog(context);

        final Map<String, dynamic> data = {'email': lastNameController.text};

        // done , now run app
        RestClient apiService = RestClient(dio.Dio());

        final response = await apiService.resetPassword(data);

        switch (response.resetPasswordEntity.responseCode) {
          case "200":
            {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
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
      }
    }

    Future<String> checkEmail() async {
      final Map<String, dynamic> data = {'email_id': lastNameController.text};

      // done , now run app
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.emailVerify(data);

      switch (response.emailEntity.responseCode) {
        case "200":
          Fluttertoast.showToast(
              msg: "Enter registered email",
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              toastLength: Toast.LENGTH_SHORT);
          break;

        case "400":

        case "500":
          break;
      }

      return _errormsg;
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: Text("Forgot Password"),
            elevation: 0.1,
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
                        "Forgot Password ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "We just need your registered Email id to send you password reset instructions.",
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      validator: validateEmail,
                      controller: lastNameController,
                      onChanged: (value) async {
                        checkEmail();
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        errorText: validatePassword(lastNameController.text),
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
                          child: new Text('Forgot Password',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: checkEmailPresence,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: new GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (route) => false);
                      },
                      child: new Text("Back to Login"),
                    )),
                  ],
                ),
              ),
            ),
          ),
        )));
  }
}
