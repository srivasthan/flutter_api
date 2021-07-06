import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/user.dart';
import 'package:flutter_api_json_parse/providers/user_provider.dart';
import 'package:flutter_api_json_parse/screens/myProduct.dart';
import 'package:provider/provider.dart';
import 'home.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _pageIndex = 0;
  PageController _pageController;
  String cusCode, token;

  List<Widget> tabPages = [
    HomeStateless(),
    MyProductStateless(),
    Screen3(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _pageIndex,
        onTap: onTabTapped,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.mail), title: Text("My Product")),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text("Profile")),
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
