import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/raiseTicket.dart';
import 'package:flutter_api_json_parse/screens/ticket_list.dart';
import 'home.dart';
import 'myProduct.dart';
import 'amc.dart';

class DashBoard extends StatelessWidget {
  int selectedPage;
  int _pageCount = 5;

  DashBoard(this.selectedPage);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: _pageCount,
      child: Scaffold(
        bottomNavigationBar: menu(context),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomeStateless(),
            RaiseTicketStateless(),
            TicketListStateless(),
            MyProductStateless(),
            AmcStateless(),
          ],
        ),
      ),
    );
  }

  Widget menu(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 70,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        physics: const NeverScrollableScrollPhysics(),
        indicatorPadding: EdgeInsets.zero,
        tabs: [
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(Icons.home),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Home",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(Icons.event_note_outlined),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Raise Ticket",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(Icons.event_note_outlined),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Ticket List",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(Icons.folder),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "My Product",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ),
          Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Icon(Icons.sticky_note_2_sharp),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "AMC",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.0),
              )
            ],
          ),
        ],
      ),
    );
  }
}
