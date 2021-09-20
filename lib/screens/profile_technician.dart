import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProfileTechnician extends StatefulWidget {
  @override
  _ProfileTechnicianState createState() => _ProfileTechnicianState();
}

class _ProfileTechnicianState extends State<ProfileTechnician> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/profile_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        onPressed: () {},
                        color: Colors.white,
                        icon: Icon(Icons.arrow_back_ios_outlined)),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        "V1.1",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 3, right: 3, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text(
                                "Sumitha Nesamani",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: 15, top: 2),
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
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Stack(
                        children: <Widget>[
                          CircleAvatar(
                            radius: 45,
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/user_image.png',
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 1,
                              right: 1,
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Icon(
                                  Icons.add_a_photo,
                                  color: Colors.white,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Container(
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
                            width: 50,
                            height: 50,
                            margin: EdgeInsets.only(right: 5),
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(
                                Icons.person_rounded,
                                size: 30,
                              ),
                            )),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 7,
                            ),
                            Text("Full Name",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text("Sumitha Nesamani"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.email_outlined,
                              size: 30,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Text("Email",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Text("technician@kaspontech.com"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.call,
                              size: 30,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Text("Mobile no",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Text("8451111112"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 30,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Text("Address",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                child: Text(
                                    "12, Sardar Patel Road, Guindy, Chennai, Tamil Nadu, India - 600025",
                                    overflow: TextOverflow.visible),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
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
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: 5),
                          child: Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.location_city,
                              size: 30,
                            ),
                          )),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 7,
                          ),
                          Text("Work Location",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              Flexible(
                                  child: Text(
                                "4/925, Nehru Nagar, Perungudi, Chennai, Tamil Nadu 600096, India",
                                overflow: TextOverflow.visible,
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
