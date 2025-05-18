import 'package:flutter/material.dart';

class AppColor {
  static AppColorBase? _theme;
  static final _blueColor = BlueColor();
  static final _pinkColor = PinkColor();

  AppColor._();

  static AppColorBase get instance {
    _theme ??= BlueColor();
    return _theme!;
  }

  static void init(bool isBlueMode) {
    _theme = isBlueMode ? _blueColor : _pinkColor;
  }

  static void updateTheme() {
    final newTheme = _theme is BlueColor ? _pinkColor : _blueColor;
    _theme = newTheme;
  }

  static Color get primary => instance.primary;
  static Color get secondary => instance.secondary;
  static Color get secondaryAccent => instance.secondaryAccent;
  static Color get accent => instance.accent;
  static Color get error => instance.error;
  static Color get errorText => instance.errorText;
  static Color get white => instance.white;
  static Color get black => instance.black;
  static Color get whiteAccent => instance.whiteAccent;
}

abstract class AppColorBase {
  Color get primary;
  Color get secondary;
  Color get secondaryAccent;
  Color get accent;
  Color get error;
  Color get errorText;
  Color get white;
  Color get black;
  Color get whiteAccent;
}

class BlueColor implements AppColorBase {
  @override
  Color primary = Colors.blue;
  @override
  Color secondary = const Color.fromARGB(255, 247, 247, 247);
  @override
  Color secondaryAccent = const Color.fromARGB(255, 234, 232, 232);
  @override
  Color accent = const Color.fromARGB(255, 59, 73, 80);
  @override
  Color error = Colors.red;
  @override
  Color errorText = const Color(0xffff3131);
  @override
  Color white = Colors.white;
  @override
  Color black = Colors.black;
  @override
  Color whiteAccent = const Color.fromARGB(255, 114, 110, 110);
}

class PinkColor implements AppColorBase {
  @override
  Color primary = Colors.pinkAccent;
  @override
  Color secondary = const Color.fromARGB(255, 247, 247, 247);
  @override
  Color secondaryAccent = const Color.fromARGB(255, 234, 232, 232);
  @override
  Color accent = const Color.fromARGB(255, 59, 73, 80);
  @override
  Color error = Colors.red;
  @override
  Color errorText = const Color(0xffff3131);
  @override
  Color white = Colors.white;
  @override
  Color black = Colors.black;
  @override
  Color whiteAccent = const Color.fromARGB(255, 114, 110, 110);
}
