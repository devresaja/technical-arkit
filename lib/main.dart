import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/core/routes/route.dart';
import 'package:technical_artkit/core/theme/bloc/theme_bloc.dart';
import 'package:technical_artkit/core/theme/theme.config.dart';
import 'package:technical_artkit/firebase_options.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/services/app_lifecycle_service.dart';
import 'package:technical_artkit/services/local_storage_service.dart';
import 'package:technical_artkit/utils/navigator_key.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AppLifecycleService.instance.initialize();

  AppColor.init(false);

  final isBlueMode = await LocalStorageService.getIsBlueMode();

  runApp(MyApp(isBlueMode: isBlueMode));
}

class MyApp extends StatefulWidget {
  final bool isBlueMode;

  const MyApp({super.key, required this.isBlueMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _themeBloc = ThemeBloc();

  @override
  void initState() {
    super.initState();
    AppColor.init(widget.isBlueMode);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _themeBloc,
      child: BlocBuilder<ThemeBloc, ThemeState>(
        bloc: _themeBloc,
        buildWhen:
            (previous, current) => previous.isBlueMode != current.isBlueMode,
        builder: (context, state) {
          log('isBlueMode: ${widget.isBlueMode}');
          return MaterialApp(
            debugShowCheckedModeBanner: kDebugMode,
            title: 'MiniChatApp',
            theme: themeConfig(isBlueMode: widget.isBlueMode),
            navigatorKey: navigatorKey,
            builder:
                (context, child) => SafeArea(
                  top: false,
                  right: false,
                  left: false,
                  child: child!,
                ),
            home: LoginScreen(),
            onGenerateRoute: RouteConfig.generateRoute,
          );
        },
      ),
    );
  }
}
