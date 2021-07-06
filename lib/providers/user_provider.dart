import 'package:flutter/cupertino.dart';
import 'package:flutter_api_json_parse/domain/country.dart';
import 'package:flutter_api_json_parse/domain/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User();

  User get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}

class CountryName extends ChangeNotifier {
  CountryModel _user = CountryModel();

  CountryModel get user => _user;

  void setCountryName(CountryModel user) {
    _user = user;
    notifyListeners();
  }
}
