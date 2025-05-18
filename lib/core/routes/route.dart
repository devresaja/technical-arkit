import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:technical_artkit/core/error/not_found_screen.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/modules/chat/screen/all_user_screen.dart';
import 'package:technical_artkit/modules/chat/screen/chat_screen.dart';
import 'package:technical_artkit/modules/chat/screen/chat_detail_screen.dart';
import 'package:technical_artkit/modules/profile/screen/profile_screen.dart';

class RouteConfig {
  static String routeName = '';
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    var argument = settings.arguments;
    log('route name: ${settings.name}');

    routeName = settings.name!;

    switch (settings.name) {
      case LoginScreen.path:
        return goTo(const LoginScreen());

      case ChatScreen.path:
        return goTo(const ChatScreen());

      case ChatDetailScreen.path:
        return goTo(ChatDetailScreen(argument: argument as ChatDetailArgument));

      case AllUserScreen.routeName:
        return goTo(const AllUserScreen());

      case ProfileScreen.path:
        return goTo(ProfileScreen(argument: argument as ProfileArgument));

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
