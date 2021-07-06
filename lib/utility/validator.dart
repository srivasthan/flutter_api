import 'package:flutter_api_json_parse/network/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_api_json_parse/providers/auth_provider.dart';
import 'package:provider/provider.dart';

String validateEmail(String value) {
  String _msg;
  RegExp regex = new RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (value.isEmpty) {
    _msg = "Your username is required";
  } else if (!regex.hasMatch(value)) {
    _msg = "Please provide a valid emal address";
  }

  return _msg;
}

String validateMobile(String value) {
  String _msg;
  if (value.isEmpty) {
    _msg = "Please enter mobile number";
  } else if (value.length < 10) {
    _msg = "mobile number should be 10 numbers";
  } else if (!value.startsWith("6") &&
      !value.startsWith("7") &&
      !value.startsWith("8") &&
      !value.startsWith("9")) {
    _msg = "Contact Number Should Start from 6,7,8,9";
  }

  return _msg;
}

String validateAlternateMobile(String value) {
  String _msg;
  if (value.isEmpty) {
    _msg = "Please enter alternate number";
  } else if (value.length < 10) {
    _msg = "alternate number should be 10 numbers";
  } else if (!value.startsWith("6") &&
      !value.startsWith("7") &&
      !value.startsWith("8") &&
      !value.startsWith("9")) {
    _msg = "Alternate Number Should Start from 6,7,8,9";
  }

  return _msg;
}

String validatePostcode(String value) {
  String _msg;
  if (value.isEmpty) {
    _msg = "Please enter postcode";
  } else if (value.length < 6) {
    _msg = "postcode should be 6 numbers";
  }

  return _msg;
}