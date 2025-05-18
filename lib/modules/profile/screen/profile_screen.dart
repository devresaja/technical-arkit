import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/auth/bloc/auth_bloc.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/button/custom_button.dart';

class ProfileArgument {
  final String userId;
  final bool isMe;

  ProfileArgument({required this.userId, this.isMe = false});
}

class ProfileScreen extends StatefulWidget {
  final ProfileArgument argument;

  static const String path = '/profile';

  const ProfileScreen({super.key, required this.argument});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    UserProfileWidget(
                      userId: widget.argument.userId,
                      imageSize: 120,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      showOnlineStatus: !widget.argument.isMe,
                      isVertical: true,
                    ),
                    divide24,
                  ],
                ),
              ),
            ),
          ),
          if (widget.argument.isMe) _buildLogoutButton(),
        ],
      ),
    );
  }

  Container _buildLogoutButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: BlocProvider(
        create: (context) => _authBloc,
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is LogoutLoadedState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                LoginScreen.path,
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            return CustomButton(
              text: 'Logout',
              isLoading: state is LogoutLoadingState,
              onTap: () {
                showConfirmationDialog(
                  context: context,
                  title: 'Are you sure want to logout?',
                  onTapOk: () {
                    Navigator.pop(context);
                    _authBloc.add(LogoutEvent(userId: widget.argument.userId));
                  },
                );
              },
              color: Colors.red.shade500,
              padding: const EdgeInsets.symmetric(vertical: 12),
            );
          },
        ),
      ),
    );
  }
}
