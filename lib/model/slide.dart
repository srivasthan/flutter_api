import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/dashboard_menu.dart';

class Slide {
  // final String imageUrl;
  final DashBoardMenuOne dashBoardMenuOne;

  // final DashBoardMenuTwo dashBoardMenuTwo;
  // final String title;
  // final String description;

  Slide({
    //  @required this.imageUrl,
    @required this.dashBoardMenuOne,
    // @required this.dashBoardMenuTwo,
    // @required this.title,
    // @required this.description,
  });
}

final slideList = [
  // Slide(
  //   imageUrl: 'assets/images/image1.jpg',
  //   title: 'A Cool Way to Get Start',
  //   description:
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  // ),
  // Slide(
  //   imageUrl: 'assets/images/image2.jpg',
  //   title: 'Design Interactive App UI',
  //   description:
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  // ),
  // Slide(
  //   imageUrl: 'assets/images/image3.jpg',
  //   title: 'It\'s Just the Beginning',
  //   description:
  //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec dapibus tincidunt bibendum. Maecenas eu viverra orci. Duis diam leo, porta at justo vitae, euismod aliquam nulla.',
  // ),

  Slide(
    dashBoardMenuOne: new DashBoardMenuOne(),
  ),
  // Slide(dashBoardMenuTwo: new DashBoardMenuTwo())
];
