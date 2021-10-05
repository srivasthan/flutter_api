import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/ticket_list.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shimmer/shimmer.dart';

class TicketListStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TicketList(
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

class TicketList extends StatefulWidget {
  final Function onInit;
  final Widget child;

  const TicketList({@required this.onInit, @required this.child});

  @override
  _TicketList createState() => _TicketList();
}

class _TicketList extends State<TicketList> {
  final formKey = GlobalKey<_TicketList>();

  String token,
      cusCode,
      newToken,
      product,
      subProduct,
      serialNumber,
      modelNumber,
      contractType,
      status;
  List<TicketListModel> _ticketList = new List<TicketListModel>();
  TicketListModel _ticketListModel;
  bool isListEmpty = true;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  getMyProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = (prefs.getString('token') ?? '');
      cusCode = (prefs.getString("cuscode") ?? '');
    });

    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      RestClient apiService = RestClient(dio.Dio());

      final response = await apiService.getTicket(token, cusCode);

      if (response.ticketListResponse.responseCode == "200") {
        setState(() {
          newToken = response.ticketListResponse.token;
          for (int i = 0; i < response.ticketListResponse.data.length; i++) {
            _ticketList.add(new TicketListModel(
                ticketId: response.ticketListResponse.data[i].ticketId,
                product: response.ticketListResponse.data[i].product,
                subProduct: response.ticketListResponse.data[i].subProduct,
                model: response.ticketListResponse.data[i].model,
                serialNo: response.ticketListResponse.data[i].serialNo,
                technicainName:
                    response.ticketListResponse.data[i].technicainName,
                technicianNumber:
                    response.ticketListResponse.data[i].technicianNumber,
                raisedDateTime:
                    response.ticketListResponse.data[i].raisedDateTime,
                workType: response.ticketListResponse.data[i].workType,
                problemDesc: response.ticketListResponse.data[i].problemDesc,
                statusCode: response.ticketListResponse.data[i].statusCode,
                statusName: response.ticketListResponse.data[i].statusName));
          }

          prefs.setString('token', newToken.toString());
        });
      } else if (response.ticketListResponse.responseCode == "400") {
        setState(() {
          prefs.setString('token', response.ticketListResponse.token);
          isListEmpty = false;
        });
      } else if (response.ticketListResponse.responseCode == "500") {
        setState(() {
          isListEmpty = false;
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
    await Future.delayed(Duration(seconds: 0));
    setState(() {
      _ticketList.clear();
      getMyProductList();
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getMyProductList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: Text("TicketList"),
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
    return isListEmpty == true
        ? Shimmer.fromColors(
            baseColor: Colors.white30,
            highlightColor: Colors.white60,
            child: Column(
              children: [
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
                                                style: TextStyle(fontSize: 11)),
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
          )
        : _ticketList.isNotEmpty
            ? ListView.builder(
                itemCount: _ticketList.length,
                padding: const EdgeInsets.all(5.0),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => showTicketDetails(context, index),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              new Padding(padding: new EdgeInsets.all(5.0)),
                              new Expanded(
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Ticket ID                 ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              new Expanded(
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(_ticketList[index].ticketId,
                                          style: TextStyle(fontSize: 15)),
                                    ),
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
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Ticket Raise Date  ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              new Expanded(
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                          _ticketList[index].raisedDateTime,
                                          style: TextStyle(fontSize: 15)),
                                    ),
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
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Work Type               ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              new Expanded(
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(_ticketList[index].workType,
                                          style: TextStyle(fontSize: 15)),
                                    ),
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
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Text("Status                      ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                              new Expanded(
                                flex: 0,
                                child: new Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(_ticketList[index].statusName,
                                          style: TextStyle(fontSize: 15)),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )
                        ])),
                  );
                })
            : Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/no_data.png"),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      "No Data Available",
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              );
  }

  void showTicketDetails(BuildContext context, int index) {
    Dialog alertDialog = Dialog(
        insetPadding: EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: double.infinity,
            child: Column(children: [
              Expanded(
                flex: 0,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.black, borderRadius: BorderRadius.zero),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              _ticketList[index].ticketId,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white,
                                )),
                          ),
                        )
                      ],
                    )),
              ),
              Expanded(
                flex: 0,
                child: Container(
                    padding: EdgeInsets.only(top: 5),
                    child:
                        new Column(mainAxisSize: MainAxisSize.min, children: <
                            Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          new Padding(padding: new EdgeInsets.all(5.0)),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Product                          ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].product ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Sub Product                  ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].subProduct ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Model                             ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].model,
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Serial Number               ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].serialNo ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Technician Name         ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].technicainName ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Technician Number     ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    _ticketList[index].technicianNumber ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Work Type                     ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].workType ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Description                   ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].problemDesc ?? "NA",
                                    style: TextStyle(fontSize: 14)),
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
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Status                            ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 0,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_ticketList[index].statusName ?? "NA",
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                    ])),
              )
            ]),
          ),
        ]));
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
