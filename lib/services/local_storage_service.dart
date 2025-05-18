import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userData = 'userData';
  static const String isBlueMode = 'isBlueMode';

  static Future<bool> getIsBlueMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isBlueMode) ?? true;
  }

  static Future<bool> setIsBlueMode(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isBlueMode, value);
  }

  static Future<void> removeValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(userData);
  }
}
