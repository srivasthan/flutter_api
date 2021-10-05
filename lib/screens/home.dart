import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_json_parse/domain/myProductList.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shimmer/shimmer.dart';

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
  String cusCode, token, email, newToken, name;
  List<MyProductListModel> myProductList = new List<MyProductListModel>();
  MyProductListModel myProductListModel;
  bool _showList = false;

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cusCode = (prefs.getString('cuscode') ?? '');
    name = (prefs.getString('name') ?? '');
    email = (prefs.getString("email") ?? '');

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final Map<String, dynamic> loginData = {'customer_code': cusCode};

      final response = await apiService.postTokenActivity(loginData);

      if (response.tokenEntity.responseCode == "200") {
       if(mounted){
         setState(() {
           token = response.tokenEntity.data;
           getMyProductList();
         });
       }
      }

      prefs.setString('token', token.toString());
    } else {
      Fluttertoast.showToast(
          msg: "Connect to internet",
          timeInSecForIosWeb: 1,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  getMyProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getMyProductList(token, email);

      if (response.myProductListEntity.responseCode == "200") {
      if(mounted){
        setState(() {
          newToken = response.myProductListEntity.token;
          for (int i = 0;
          i < response.myProductListEntity.myProductList.length;
          i++) {
            myProductList.add(new MyProductListModel(
                product: response.myProductListEntity.myProductList[i].product,
                subProduct:
                response.myProductListEntity.myProductList[i].subProduct,
                serialNo:
                response.myProductListEntity.myProductList[i].serialNo,
                modelNo: response.myProductListEntity.myProductList[i].modelNo,
                contractType:
                response.myProductListEntity.myProductList[i].contractType,
                contractStatusName: response
                    .myProductListEntity.myProductList[i].contractStatusName));
          }

          prefs.setString('token', newToken.toString());
          _showList = true;
        });
      }
      }
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
        body: _showList == true
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Welcome, Good Morning",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w800))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w400))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color(int.parse("0xfff" + "EEF2F4")),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "30",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Total Products Present",
                                          textAlign: TextAlign.center,
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color(int.parse("0xfff" + "EEF2F4")),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "30",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Text(
                                          "Total Tickets Risen",
                                          textAlign: TextAlign.center,
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                              color: Color(int.parse("0xfff" + "EEF2F4")),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "30",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: Text("Tickets in Progress",
                                                textAlign: TextAlign.center))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: SingleChildScrollView(
                      child: Visibility(
                        visible: _showList,
                        child: Container(child: getTasListView()),
                      ),
                    ),
                  )
                ],
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey[300],
                highlightColor: Colors.grey[400],
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Welcome, Good Morning",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w800))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Kaspon",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w400))
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Color(int.parse("0xfff" + "EEF2F4")),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "30",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Total Products Present",
                                            textAlign: TextAlign.center,
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Color(int.parse("0xfff" + "EEF2F4")),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "30",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text(
                                            "Total Tickets Risen",
                                            textAlign: TextAlign.center,
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Color(int.parse("0xfff" + "EEF2F4")),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "30",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                              child: Text("Tickets in Progress",
                                                  textAlign: TextAlign.center))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListView.builder(
                        itemCount: 5,
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return new Container(
                              padding: EdgeInsets.only(top: 10),
                              child: new Card(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 7.5),
                                      child: Row(
                                        children: [
                                          new Padding(
                                              padding: new EdgeInsets.all(5.0)),
                                          new Expanded(
                                            child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text("NA",
                                                    style: TextStyle(
                                                        fontSize: 11)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                  ])));
                        }),
                  ],
                ),
              ));
  }

  Widget getTasListView() {
    return ListView.builder(
        itemCount: myProductList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              color: Colors.white,
            ),
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(right: 25),
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/images/cardiology.png',
                        ),
                      )),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(myProductList[index].product,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(myProductList[index].subProduct,
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(myProductList[index].modelNo,
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(myProductList[index].contractType,
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Text(myProductList[index].contractStatusName,
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
