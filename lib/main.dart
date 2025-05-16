import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/core/routes/route.dart';
import 'package:technical_artkit/firebase_options.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/utils/navigator_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppColor.init(false);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      title: 'MiniChatApp',
      navigatorKey: navigatorKey,
      builder:
          (context, child) =>
              SafeArea(top: false, right: false, left: false, child: child!),
      initialRoute: LoginScreen.path,
      onGenerateRoute: RouteConfig.generateRoute,
    );
  }
}
