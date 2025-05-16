import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

class LocalStorageService {
  static const String userData = 'userData';
  static const String isDarkMode = 'isDarkMode';

  static Future<bool> getIsDarkMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isDarkMode) ?? true;
  }

  static Future<bool> setIsDarkMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isDarkMode, value);
  }

  static Future<UserData?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(userData);

    if (data != null) {
      final Map<String, dynamic> value = jsonDecode(data);

      return UserData.fromJson(value);
    }

    return null;
  }

  static Future<bool> setUserData(UserData value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(value.toJson());

    return prefs.setString(userData, data);
  }

  static Future<void> removeValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userData);
  }
}
