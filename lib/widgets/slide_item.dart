import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/dashboard_menu.dart';

import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;

  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2 / 1,
            children: List.generate(choices.length, (index) {
              return Padding(
                padding: EdgeInsets.only(top: 5),
                child: Center(
                  child: ChoiceCard(choice: choices[index]),
                ),
              );
            }))
      ],
    );
  }
}
