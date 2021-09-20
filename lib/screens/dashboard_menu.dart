import 'dart:math';

import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/dashboard_menu_page1.dart';
import 'package:flutter_api_json_parse/screens/getting_started_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DashBoardMenu extends StatefulWidget {
  @override
  _DashBoardMenuState createState() => _DashBoardMenuState();
}

class _DashBoardMenuState extends State<DashBoardMenu> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  double _rating = 0.0;
  bool status = false;
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  final _kArrowColor = Colors.black.withOpacity(0.8);

  final List<Widget> _pages = <Widget>[
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: new DashBoardMenuOne(),
    ),
    new ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: DashBoardMenuTwo(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: Colors.black12,
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/menu_bg_drawable.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 3, right: 3, top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: SizedBox(
                          height: 80,
                          width: 80,
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/user_image.png',
                              fit: BoxFit.cover,
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Sumitha Nesamani",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2),
                            child: RatingBar.builder(
                              itemSize: 26,
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                print(rating);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: CustomSwitch(
                        activeColor: Color(int.parse("0xfff" + "4a777c")),
                        value: status,
                        onChanged: (value) {
                          // print("VALUE : $value");
                          // setState(() {
                          //   status = value;
                          // });
                        },
                      ),
                    ),
                    // new MyHomePage(),
                  ],
                ),
              ),
            ),
            Container(
              height: 200,
              child: new IconTheme(
                data: new IconThemeData(color: _kArrowColor),
                child: new Stack(
                  children: <Widget>[
                    new PageView.builder(
                      physics: new AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index % _pages.length];
                      },
                    ),
                    new Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: new Container(
                        padding: const EdgeInsets.all(20.0),
                        child: new Center(
                          child: new DotsIndicator(
                            controller: _controller,
                            itemCount: _pages.length,
                            onPageSelected: (int page) {
                              _controller.animateToPage(
                                page,
                                duration: _kDuration,
                                curve: _kCurve,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class DashBoardMenuOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 2 / 1,
                children: List.generate(choices.length, (index) {
                  return Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Center(
                      child: ChoiceCard(choice: choices[index]),
                    ),
                  );
                }))));
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const [
  const Choice(title: 'Home', icon: Icons.home_filled),
  const Choice(title: 'Ticket list', icon: Icons.assignment_outlined),
  const Choice(title: 'Service report', icon: Icons.assignment_outlined),
  const Choice(title: 'Spare Inventory', icon: Icons.assignment_outlined),
  const Choice(title: 'Training', icon: Icons.assignment_outlined),
  const Choice(title: 'Knowledge base', icon: Icons.assignment_outlined),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Expanded(child: Icon(choice.icon, size: 40.0)),
        Text(choice.title, style: TextStyle(fontSize: 15)),
      ]),
    );
  }
}

class DashBoardMenuTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 2 / 1,
              children: List.generate(choices1.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Center(
                    child: ChoiceCard(choice: choices1[index]),
                  ),
                );
              }))),
    ));
  }
}

class Choice1 {
  const Choice1({this.title1, this.icon1});

  final String title1;
  final IconData icon1;
}

const List<Choice> choices1 = const [
  const Choice(title: 'Amc contract', icon: Icons.home_filled),
  const Choice(title: 'Reimbursement', icon: Icons.assignment_outlined),
  const Choice(title: 'Smart Scheduling', icon: Icons.assignment_outlined),
];

class ChoiceCard1 extends StatelessWidget {
  const ChoiceCard1({Key key, this.choice1}) : super(key: key);

  final Choice choice1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: [
        Expanded(child: Icon(choice1.icon, size: 40.0)),
        Text(choice1.title, style: TextStyle(fontSize: 15)),
      ]),
    );
  }
}
