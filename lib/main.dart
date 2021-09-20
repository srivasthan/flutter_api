import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/providers/user_provider.dart';
import 'package:flutter_api_json_parse/screens/addAmc.dart';
import 'package:flutter_api_json_parse/screens/addProduct.dart';
import 'package:flutter_api_json_parse/screens/amc.dart';
import 'package:flutter_api_json_parse/screens/dashboard.dart';
import 'package:flutter_api_json_parse/screens/dummy1.dart';
import 'package:flutter_api_json_parse/screens/dummy2.dart';
import 'package:flutter_api_json_parse/screens/forgotPassword.dart';
import 'package:flutter_api_json_parse/screens/myProduct.dart';
import 'package:flutter_api_json_parse/screens/passwordChange.dart';
import 'package:flutter_api_json_parse/screens/profile.dart';
import 'package:flutter_api_json_parse/screens/profile_technician.dart';
import 'package:flutter_api_json_parse/screens/register.dart';
import 'package:flutter_api_json_parse/utility/userPreferences.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'domain/user.dart';
import 'screens/login.dart';

void main() async {
  Function originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await Crashlytics.instance.recordFlutterError(errorDetails);
    originalOnError(errorDetails);
  };

  Crashlytics.instance.enableInDevMode = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Login Registration',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: getUserData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else if (snapshot.data.token == null)
                    return Login();
                  else
                    Provider.of<UserProvider>(context).setUser(snapshot.data);
                  return DashBoard(0);
              }
            }),
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/dashboard': (context) => DashBoard(0),
          '/forgotPassword': (context) => ForgotPassword(),
          '/profile': (context) => Profile(),
          '/passwordChange': (context) => PasswordChange(),
          '/addproduct': (context) => AddProduct(),
          '/myproduct': (context) => MyProductStateless(),
          '/amc': (context) => AmcStateless(),
          '/addamc': (context) => AddAmc(),
          '/dummylogin': (context) => Dummy(),
          '/dummyForgotPassword': (context) => Dummy1(),
          '/technicianProfile': (context) => ProfileTechnician()
        },
      ),
    );
  }
}
