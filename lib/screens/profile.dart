import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flushbar/flushbar.dart';
import 'package:flutter_api_json_parse/utility/validator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_api_json_parse/utility/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<_ProfileState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  var stringValue;
  String token,
      cusCode,
      getName,
      getEmail,
      getMobile,
      getToken,
      getProfileResponseToken;

  Future<bool> _onBackPressed() {
    return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: const Text(
                    "FieldPro",
                    style: TextStyle(fontSize: 20),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const [
                        Text(
                          "Do you want to exit?",
                          style: TextStyle(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/dashboard', (route) => false);
                            },
                            padding: EdgeInsets.all(0.0),
                            child: const Text(
                              'Yes',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            )),
                        FlatButton(
                            onPressed: () => {Navigator.pop(context)},
                            padding: EdgeInsets.only(left: 0.0),
                            child: const Text(
                              "No",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.lightBlue),
                            ))
                      ],
                    ),
                  ],
                )) ??
        false;
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getCustomerToken(String cusCode) async {
    RestClient apiService = RestClient(dio.Dio());

    final Map<String, dynamic> loginData = {'customer_code': cusCode};

    final response = await apiService.postTokenActivity(loginData);

    if (response.tokenEntity.responseCode == "200") {
      setState(() {
        getToken = response.tokenEntity.data;
        getFinalProfile(getToken, cusCode);
      });
    }
  }

  getProfileDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      stringValue = (prefs.getString('cuscode') ?? '');
    });

    getCustomerToken(stringValue);
  }

  getFinalProfile(String token, String cuscode) async {
    RestClient apiService = RestClient(dio.Dio());

    final response = await apiService.getProfile(token, cuscode);

    if (response.profileEntity.responseCode == "200") {
      setState(() {
        getProfileResponseToken = response.profileEntity.token;
        getName = response.profileEntity.profileSaveEntity.cusName;
        getEmail = response.profileEntity.profileSaveEntity.email;
        getMobile = response.profileEntity.profileSaveEntity.phone;
      });

      nameController.value = TextEditingValue(text: getName.toString());
      emailController.value = TextEditingValue(text: getEmail.toString());
      mobileController.value = TextEditingValue(text: getMobile.toString());

      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  changePassword() async {
    //showAlertDialog(context);
    final Map<String, dynamic> loginData = {
      'customer_code': stringValue,
      'customer_name': nameController.text,
      'email_id': emailController.text,
      'contact_number': mobileController.text,
      'alternate_number': ''
    };

    RestClient apiService = RestClient(dio.Dio());

    final response =
        await apiService.editProfile(getProfileResponseToken, loginData);

    if (response.responseEntity.responseCode == "200") {
      setState(() {
        showAlertDialog(context);
        getProfileDetails();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showAlertDialog(context);
    });
    getProfileDetails();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> checkEmailPresence() async {
      Flushbar(
        title: "Success",
        message: "Under Development",
        duration: Duration(seconds: 3),
      ).show(context);
    }

    return new WillPopScope(
        onWillPop: _onBackPressed,
        child: new Scaffold(
          appBar: AppBar(
            title: Text("Profile"),
            elevation: 0.1,
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50.0,
                    ),
                    Center(
                      child: Text(
                        "Customer Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      validator: (value) =>
                          value.isEmpty ? "Please enter " : null,
                      controller: nameController,
                      decoration: buildInputDecoration(
                          'Enter Name', Icons.account_circle_rounded),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: emailController,
                      validator: validateEmail,
                      decoration:
                          buildInputDecoration('Enter Email', Icons.email),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: mobileController,
                      validator: validateMobile,
                      decoration:
                          buildInputDecoration('Enter Mobile', Icons.phone),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Material(
                        //Wrap with Material
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        // elevation: 18.0,
                        color: Colors.lightBlue,
                        clipBehavior: Clip.antiAlias,
                        // Add This
                        child: MaterialButton(
                          minWidth: 200.0,
                          height: 35,
                          child: new Text('Change Password',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: checkEmailPresence,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Material(
                        //Wrap with Material
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22.0)),
                        // elevation: 18.0,
                        color: Colors.lightBlue,
                        clipBehavior: Clip.antiAlias,
                        // Add This
                        child: MaterialButton(
                          minWidth: 200.0,
                          height: 35,
                          child: new Text('Update Profile',
                              style: new TextStyle(
                                  fontSize: 16.0, color: Colors.white)),
                          onPressed: changePassword,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

// Future<void> getFinalProfile(String getToken, String cusCode) async {
//   Dio dio = new Dio();
//   dio.options.headers['Token'] = getToken.toString();
//   final Response<Map<String, dynamic>> response = await dio.post(
//       "https://dev.kaspontech.com/djadmin/customer_profile/?customer_code=" +
//           cusCode.toString());
//
//   final value = ProfileResponse.fromJson(response.data);
//
//   Future<ProfileResponse> fina = Future.value(value);
//
//   // final response = await apiService.getProfile(getToken, stringValue);
//
// }
}
