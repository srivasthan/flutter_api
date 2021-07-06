import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/user.dart';
import 'package:flutter_api_json_parse/providers/auth_provider.dart';
import 'package:flutter_api_json_parse/providers/user_provider.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  String _userName, _password, status;
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

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    String fcmtoken;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called');
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called');
      },
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called');
      },
    );
    _firebaseMessaging.subscribeToTopic('all');
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print('Hello');
    });
    _firebaseMessaging.getToken().then((token) {
      print(token); // Print the Token in Console
      fcmtoken = token;
    });

    AuthProvider auth = Provider.of<AuthProvider>(context);

    var doLogin = () async {
      final form = formKey.currentState;

      if (form.validate()) {
        form.save();
        final Future<Map<String, dynamic>> respose =
            auth.login(_userName, _password, fcmtoken);

        respose.then((response) {
          if (response['status']) {
            Flushbar(
              title: "Failed Login",
              message: "Login Successful",
              duration: Duration(seconds: 3),
            ).show(context);

            Navigator.pushNamedAndRemoveUntil(
                context, '/dashboard', (route) => false);
          } else {
            Flushbar(
              title: "Failed Login",
              message: "Login Failed",
              duration: Duration(seconds: 3),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: 'Invalid form',
          message: 'Please complete the form properly',
          duration: Duration(seconds: 10),
        ).show(context);
      }
    };

    final loading = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text(" Login ... Please wait")
      ],
    );

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
                    onSaved: (value) => _userName = value,
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
                    validator: (value) =>
                        value.isEmpty ? 'Please enter password' : null,
                    onSaved: (value) => _password = value,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  auth.loggedInStatus == Status.Authenticating
                      ? loading
                      : longButtons('Login', doLogin),
                  SizedBox(
                    height: 8.0,
                  ),
                  forgotLabel
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
