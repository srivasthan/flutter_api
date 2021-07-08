import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/raiseTicket.dart';
import 'home.dart';
import 'myProduct.dart';
import 'amc.dart';

class DashBoard extends StatelessWidget {
  int selectedPage;
  int _pageCount = 4;

  DashBoard(this.selectedPage);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: selectedPage,
      length: _pageCount,
      child: Scaffold(
        bottomNavigationBar: menu(),
        body: TabBarView(
          children: [
            HomeStateless(),
            RaiseTicketStateless(),
            MyProductStateless(),
            AmcStateless(),
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return Container(
      color: Colors.blue,
      height: 70,
      child: TabBar(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        tabs: [
          Tab(
            text: "Home",
            icon: Icon(Icons.home),
          ),
          Tab(
            text: "Raise Ticket",
            icon: Icon(Icons.event_note_outlined),
          ),
          Tab(
            text: "My Product",
            icon: Icon(Icons.folder),
          ),
          Tab(
            text: "AMC",
            icon: Icon(Icons.sticky_note_2_sharp),
          ),
        ],
      ),
    );
  }
}
