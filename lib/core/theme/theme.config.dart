import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData themeConfig({required bool isBlueMode, bool? useMaterial3}) {
  return ThemeData(
    useMaterial3: useMaterial3 ?? false,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    textTheme: textTheme(),
    fontFamily: 'NunitoSans',
    brightness: isBlueMode ? Brightness.dark : Brightness.light,
    inputDecorationTheme: inputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.primary,
      selectionHandleColor: AppColor.primary,
    ),
  );
}

Theme disableMaterial3({required bool isBlueMode, required Widget child}) {
  return Theme(
    data: themeConfig(isBlueMode: isBlueMode, useMaterial3: false),
    child: child,
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    color: AppColor.primary,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: TextStyle(fontSize: 18),
    surfaceTintColor: Colors.white,
    elevation: 0,
  );
}

TextTheme textTheme() {
  return TextTheme(
    bodyLarge: TextStyle(
      color: AppColor.secondary,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColor.primary, width: 1.5),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
  );
}
