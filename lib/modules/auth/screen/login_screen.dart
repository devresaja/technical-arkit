import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/auth/bloc/auth_bloc.dart';
import 'package:technical_artkit/modules/chat/screen/chat_screen.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/button/custom_button.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String path = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              'Welcome to MiniChatApp',
              fontSize: 18,
              weight: FontWeight.w500,
            ),
            divide28,
            BlocProvider(
              create: (context) => _authBloc,
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is LoginByGoogleLoadedState) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      ChatScreen.path,
                      (route) => false,
                    );
                  } else if (state is LoginByGoogleFailedState) {
                    showCustomSnackBar(state.message);
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    isLoading: state is LoginByGoogleLoadingState,
                    text: 'Continue with Google',
                    width: MediaQuery.of(context).size.width * 0.8,
                    onTap: () {
                      _authBloc.add(LoginByGoogleEvent());
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
