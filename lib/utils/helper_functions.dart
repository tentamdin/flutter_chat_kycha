import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggedInKey = "ISLOGGEDIN";
  static String usernameInKey = "USERNAMEKEY";
  static String userEmailInKey = "USEREMAILKEY";

  // saving data on shared preference
  static Future<void> saveUserLoggedInSharePreference(
      bool isUserLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<void> saveUsernameInSharePreference(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(usernameInKey, username);
  }

  static Future<void> saveUserEmailSharePreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userEmailInKey, userEmail);
  }

  // getting data from shared preference
  static Future<bool> getUserLoggedInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  static Future<String> getUsernameInSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(usernameInKey);
  }

  static Future<String> getUserEmailSharePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailInKey);
  }
}
