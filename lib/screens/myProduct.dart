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
              serialNo: response.myProductListEntity.myProductList[i].serialNo,
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
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      showAlert(context);
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
                  title: Text('MyProduct'),
                  automaticallyImplyLeading: false,
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
    return myProductList.isNotEmpty
        ? ListView.builder(
            itemCount: myProductList.length,
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
                              Text(myProductList[index].product,
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
                              Text("Sub Product",
                                  style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(myProductList[index].subProduct,
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
                              Text(myProductList[index].serialNo,
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
                              Text("Model No", style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(myProductList[index].modelNo,
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
                              Text("Contract Type",
                                  style: TextStyle(fontSize: 15)),
                            ],
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(myProductList[index].contractType,
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
                              Text(myProductList[index].contractStatusName,
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
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset("assets/images/no_data.png"),
              Center(
                child: Text(
                  "No Data Available",
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          );
  }
}
