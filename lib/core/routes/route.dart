import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:technical_artkit/core/error/not_found_screen.dart';

class RouteConfig {
  static String routeName = '';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    log('route name: ${settings.name}');

    routeName = settings.name!;

    switch (settings.name) {
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
