import 'package:flutter_api_json_parse/domain/country.dart';
import 'package:flutter_api_json_parse/domain/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('customer_code', user.cusCode);
    prefs.setString('customer_name', user.cusName);
    prefs.setString('email_id', user.email);
    prefs.setString('contact_number', user.phone);
    prefs.setString('alternate_number', user.alternateNumber);
    prefs.setString('plot_number', user.plotNumber);

    return prefs.commit();
  }

  Future<bool> saveCountryId(CountryModel countryModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('country_id', countryModel.countryId);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String cuscode = prefs.getString("customer_code");
    String name = prefs.getString("customer_name");
    String email = prefs.getString("email_id");
    String phone = prefs.getString("contact_number");
    String alternatenumber = prefs.getString("alternate_number");
    String plotnumber = prefs.getString("plot_number");

    return User(
        cusCode: cuscode,
        cusName: name,
        email: email,
        phone: phone,
        alternateNumber: alternatenumber,
        plotNumber: plotnumber);

  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('customer_code');
    prefs.remove('customer_name');
    prefs.remove('email_id');
    prefs.remove('contact_number');
    prefs.remove('alternate_number');
    prefs.remove('plot_number');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
