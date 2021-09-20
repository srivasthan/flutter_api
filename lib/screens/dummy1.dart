import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_api_json_parse/screens/dummy2.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';

class Dummy extends StatefulWidget {
  @override
  _DummyState createState() => _DummyState();
}

class _DummyState extends State<Dummy> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            resizeToAvoidBottomInset: false,
            body: new Builder(
              builder: (BuildContext context) {
                return new Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/loginscreen_backgrd.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: new Center(
                    child: new Container(
                      child: Padding(
                        padding: EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Container(
                          child: new Card(
                            color: Colors.white,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            margin: EdgeInsets.only(right: 15.0, left: 15.0),
                            child: new Wrap(
                              children: <Widget>[
                                Center(
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 20.0),
                                    child: new Text(
                                      'Login',
                                      style: TextStyle(fontSize: 20.0),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0, right: 20.0, left: 20.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                        prefixIcon:
                                            Icon(Icons.person_add_alt_1)),
                                    validator: validateEmail,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20.0, right: 20.0, left: 20.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    decoration: InputDecoration(
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.lock)),
                                    validator: validateEmail,
                                  ),
                                ),
                                new Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 150,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(int.parse(
                                                  "0xfff" + "898e8f")),
                                              Color(
                                                  int.parse("0xfff" + "507a7d"))
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              offset: Offset(5, 5),
                                              blurRadius: 10,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          new Dummy1()));
                                            },
                                            child: Text('SIGN IN',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // child: Material(
                                    //   //Wrap with Material
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(8.0)),
                                    //   // elevation: 18.0,
                                    //   color: Colors.lightBlue,
                                    //   clipBehavior: Clip.antiAlias,
                                    //   // Add This
                                    //   child: MaterialButton(
                                    //     minWidth: 200.0,
                                    //     height: 35,
                                    //     child: new Text('SIGN IN',
                                    //         style: new TextStyle(
                                    //             fontSize: 16.0,
                                    //             color: Colors.white)),
                                    //     onPressed: () {
                                    //       print('Login Pressed');
                                    //     },
                                    //   ),
                                    // ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20),
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 10.0, bottom: 15.0),
                                    child: Center(
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Color(
                                                int.parse("0xfff" + "2b6c72")),
                                            fontSize: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}
