import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:technical_artkit/core/error/not_found_screen.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/modules/home/screen/home_screen.dart';

class RouteConfig {
  static String routeName = '';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    log('route name: ${settings.name}');

    routeName = settings.name!;

    switch (settings.name) {
      case LoginScreen.path:
        return goTo(const LoginScreen());

      case HomeScreen.path:
        return goTo(const HomeScreen());

      default:
        return goTo(const NotFoundScreen());
    }
  }

  static MaterialPageRoute goTo(screen) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => screen,
    );
  }
}
