import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/myProductList.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;

class MyProductStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyProduct(
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

class MyProduct extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const MyProduct({@required this.onInit, @required this.child});

  @override
  _MyProduct createState() => _MyProduct();
}

class _MyProduct extends State<MyProduct> {
  final formKey = GlobalKey<_MyProduct>();

  String token,
      email,
      newToken,
      product,
      subProduct,
      serialNumber,
      modelNumber,
      contractType,
      status;
  List<MyProductListModel> myProductList = new List<MyProductListModel>();
  MyProductListModel myProductListModel;
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

  getMyProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      email = (prefs.getString("email") ?? '');
    });

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getMyProductList(token, email);

      if (response.myProductListEntity.responseCode == "200") {
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
      myProductList.clear();
      getMyProductList();
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlert(context);
    });
    getMyProductList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("My Product"),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/addproduct');
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
                  color: Colors.black12,
                  child: RefreshIndicator(
                    onRefresh: refreshList,
                    key: refreshKey,
                    child: getTasListView(),
                  ),
                ))));
  }

  Widget getTasListView() {
    if (myProductList.isEmpty) {
      isListEmpty = false;
    }
    return myProductList.isNotEmpty
        ? ListView.builder(
            itemCount: myProductList.length,
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
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     Text(myProductList[index].serialNo,
                          //         style: TextStyle(fontSize: 15)),
                          //   ],
                          // ),
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
            })
        : Visibility(
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
            visible: isListEmpty,
          );
  }
}
