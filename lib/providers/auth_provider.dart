import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_api_json_parse/domain/country.dart';
import 'package:flutter_api_json_parse/domain/register.dart';
import 'package:flutter_api_json_parse/domain/user.dart';
import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:flutter_api_json_parse/network/entity/countryEntity.dart';
import 'package:flutter_api_json_parse/network/entity/registerEntity.dart';
import 'package:flutter_api_json_parse/utility/userPreferences.dart';
import 'package:flutter_api_json_parse/utility/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registeredInStatus => _registeredInStatus;

  set registeredInStatus(Status value) {
    _registeredInStatus = value;
  }

  Future<Map<String, dynamic>> register(
      String name,
      String email,
      String mobile,
      String alternateMobile,
      int productId,
      int subProductId,
      String modelNumber,
      String serialNumber,
      String selectDate,
      int amcId,
      int contractDuration,
      String plotNumber,
      String street,
      String landMark,
      int countryId,
      int stateId,
      int cityId,
      int locationId,
      int postCode,
      String invoiceNumber) async {
    var result;
    final Map<String, dynamic> apiBodyData = {
      'customer_name': name,
      'email_id': email,
      'contact_number': mobile,
      'alternate_number': alternateMobile,
      'product_id': productId,
      'product_sub_id': subProductId,
      'model_no': modelNumber,
      'serial_no': serialNumber,
      'amc_id': amcId,
      'contract_duration': contractDuration,
      'plot_number': plotNumber,
      'street': street,
      'post_code': postCode,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'location_id': locationId,
      'landmark': landMark,
      'purchase_date': selectDate,
      'invoice_id': invoiceNumber
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    // done , now run app
    RestClient apiService = RestClient(dio.Dio());

    final response = await apiService.register(apiBodyData);

    print('${response.toJson()}');

    if (response.responseEntity.responseCode == '200') {
      RegisterEntity authUser = RegisterEntity(
          message: response.responseEntity.message,
          token: response.responseEntity.token);

      MySharedPreferences.instance
          .setStringValue("token", response.responseEntity.token);

      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {'status': false, 'message': 'Successfully registered'};
    }
    return result;
  }

  Future<Map<String, dynamic>> login(
      String email, String password, String fcmtoken) async {
    var result;

    final Map<String, dynamic> loginData = {
      'username': email,
      'password': password,
      'device_token': fcmtoken,
      'device_type': 'Android'
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    // done , now run app
    RestClient apiService = RestClient(dio.Dio());

    final response = await apiService.login(loginData);

    print('${response.toJson()}');

    if (response.responseEntity.responseCode == '200') {
      User authUser = User(
        cusCode: response.responseEntity.userEntity.cusCode,
        cusName: response.responseEntity.userEntity.cusName,
        email: response.responseEntity.userEntity.email,
        phone: response.responseEntity.userEntity.phone,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'cuscode', response.responseEntity.userEntity.cusCode.toString());
      prefs.setString(
          "email", response.responseEntity.userEntity.email.toString());

      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': 'UnSuccessful'};
    }

    return result;
  }
}
