import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/screens/profile_technician.dart';

class DummyHome extends StatefulWidget {
  @override
  _DummyHomeState createState() => _DummyHomeState();
}

class _DummyHomeState extends State<DummyHome> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(int.parse("0xfff" + "2b6c72")),
        child: Icon(Icons.calendar_view_day_sharp),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new ProfileTechnician()));
        },
      ),
      // body: new Builder(
      //   builder: (BuildContext context) {
      //     return new Container(
      //       decoration: BoxDecoration(
      //         image: DecorationImage(
      //           image:
      //           AssetImage("assets/images/loginscreen_backgrd.png"),
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //       child: new Center(
      //         child: new Container(
      //           child: Padding(
      //             padding: EdgeInsets.only(left: 30.0, right: 30.0),
      //             child: Container(
      //               child: new Card(
      //                 color: Colors.white,
      //                 elevation: 5.0,
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(8.0),
      //                 ),
      //                 margin: EdgeInsets.only(right: 15.0, left: 15.0),
      //                 child: new Wrap(
      //                   children: <Widget>[
      //                     Center(
      //                       child: new Container(
      //                         margin: EdgeInsets.only(top: 20.0),
      //                         child: new Text(
      //                           'Forgot Password',
      //                           style: TextStyle(fontSize: 20.0),
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: EdgeInsets.only(
      //                           top: 20.0, right: 20.0, left: 20.0),
      //                       child: TextFormField(
      //                         keyboardType: TextInputType.emailAddress,
      //                         controller: emailController,
      //                         autovalidateMode:
      //                         AutovalidateMode.onUserInteraction,
      //                         decoration: InputDecoration(
      //                             labelText: 'Email',
      //                             border: OutlineInputBorder(),
      //                             prefixIcon:
      //                             Icon(Icons.person_add_alt_1)),
      //                         validator: validateEmail,
      //                       ),
      //                     ),
      //                     new Center(
      //                       child: Padding(
      //                         padding: EdgeInsets.only(top: 20),
      //                         child: GestureDetector(
      //                           onTap: () {
      //                             Navigator.push(
      //                                 context,
      //                                 new MaterialPageRoute(
      //                                     builder: (context) =>
      //                                     new Dummy()));
      //                           },
      //                           child: Padding(
      //                             padding: EdgeInsets.only(bottom: 10),
      //                             child: Container(
      //                               width: 150,
      //                               height: 40,
      //                               decoration: BoxDecoration(
      //                                 gradient: LinearGradient(
      //                                   colors: [
      //                                     Color(int.parse(
      //                                         "0xfff" + "898e8f")),
      //                                     Color(int.parse(
      //                                         "0xfff" + "507a7d"))
      //                                   ],
      //                                   begin: Alignment.topLeft,
      //                                   end: Alignment.bottomRight,
      //                                 ),
      //                                 borderRadius:
      //                                 BorderRadius.circular(8),
      //                                 boxShadow: [
      //                                   BoxShadow(
      //                                     color: Colors.black12,
      //                                     offset: Offset(5, 5),
      //                                     blurRadius: 10,
      //                                   )
      //                                 ],
      //                               ),
      //                               child: Center(
      //                                 child: Text(
      //                                   'Send',
      //                                   style: TextStyle(
      //                                     color: Colors.white,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     SizedBox(
      //                       height: 10.0,
      //                     )
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     );
      //   },
      // )
    ));
  }
}
