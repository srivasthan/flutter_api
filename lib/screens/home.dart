import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class HomeStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home(
      onInit: () {
        _getThingsOnStartup().then((value) {
          print('Async done');
        });
      },
      child: Container(),
    );
  }

  Future _getThingsOnStartup() async {
    await Future.delayed(Duration(seconds: 2));
  }
}

class Home extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const Home({@required this.onInit, @required this.child});

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  String cusCode, token;

  showAlert(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text("Loading"),
          ),
        ],
      ),
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cusCode = (prefs.getString('cuscode') ?? '');
    });

    RestClient apiService = RestClient(dio.Dio());

    final Map<String, dynamic> loginData = {'customer_code': cusCode};

    final response = await apiService.postTokenActivity(loginData);

    if (response.tokenEntity.responseCode == "200") {
      setState(() {
        token = response.tokenEntity.data;
      });
    }

    prefs.setString('token', token.toString());

    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlert(context);
    });
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Home"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/profile');
            },
            child: Icon(
              Icons.account_circle_rounded,
              size: 35,
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          )
        ],
      ),
    );
  }
}
