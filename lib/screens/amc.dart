import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/amclList.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class AmcStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Amc(
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

class Amc extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const Amc({@required this.onInit, @required this.child});

  @override
  _Amc createState() => _Amc();
}

class _Amc extends State<Amc> {
  final formKey = GlobalKey<_Amc>();
  String token,
      cusCode,
      newToken,
      product,
      subProduct,
      serialNumber,
      modelNumber,
      contractType,
      status;
  List<AmcListModel> amcList = new List<AmcListModel>();
  AmcListModel amcListModel;
  bool isListEmpty = true;

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

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  getAmcList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      cusCode = (prefs.getString("cuscode") ?? '');
    });

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      final Map<String, dynamic> loginData = {'customer_code': cusCode};

      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.amcList(token, loginData);

      if (response.amcListEntity.responseCode == "200") {
        setState(() {
          newToken = response.amcListEntity.token;
          for (int i = 0; i < response.amcListEntity.amcList.length; i++) {
            amcList.add(new AmcListModel(
                product: response.amcListEntity.amcList[i].product,
                subProduct: response.amcListEntity.amcList[i].subProduct,
                serialNo: response.amcListEntity.amcList[i].serialNo,
                modelNo: response.amcListEntity.amcList[i].modelNo,
                contractType: response.amcListEntity.amcList[i].contractType,
                contractStatusName:
                    response.amcListEntity.amcList[i].contractStatusName));
          }

          prefs.setString('token', newToken.toString());

          Navigator.of(context, rootNavigator: true).pop();
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

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      showAlert(context);
      amcList.clear();
      getAmcList();
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlert(context);
    });
    getAmcList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("AMC"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/addamc');
                      },
                      child: Icon(
                        Icons.add,
                        size: 35,
                      ),
                      shape: CircleBorder(
                          side: BorderSide(color: Colors.transparent)),
                    )
                  ],
                ),
                body: Container(
                  child: RefreshIndicator(
                    onRefresh: refreshList,
                    key: refreshKey,
                    child: getTasListView(),
                  ),
                ))));
  }

  Widget getTasListView() {
    if (amcList.isEmpty) {
      isListEmpty = false;
    }

    return amcList.isNotEmpty
        ? ListView.builder(
            itemCount: amcList.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              return new Container(
                  padding: EdgeInsets.only(top: 5),
                  child: new Card(
                      child: Column(mainAxisSize: MainAxisSize.min, children: <
                          Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        new Padding(padding: new EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Product", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(amcList[index].product,
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        new Padding(padding: new EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Sub Category",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(amcList[index].subProduct,
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        new Padding(padding: new EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("AMC Type", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(amcList[index].contractType,
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        new Padding(padding: new EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Serial Number",
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(amcList[index].serialNo,
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        new Padding(padding: new EdgeInsets.all(5.0)),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Status", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  'remaining ' +
                                      amcList[index]
                                          .contractStatusName
                                          .toString() +
                                      ' days',
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ])));
            })
        : Visibility(
            visible: isListEmpty,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/images/no_data.png"),
                Center(
                  child: Text(
                    "No Data Available",
                    style: TextStyle(fontSize: 15),
                  ),
                )
              ],
            ),
          );
  }
}
