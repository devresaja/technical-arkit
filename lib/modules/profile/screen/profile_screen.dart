import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/core/theme/bloc/theme_bloc.dart';
import 'package:technical_artkit/modules/auth/bloc/auth_bloc.dart';
import 'package:technical_artkit/modules/auth/screen/login_screen.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/button/custom_button.dart';
import 'package:technical_artkit/widget/button/custom_switch_button.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
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
                        divide36,
                        if (widget.argument.isMe)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  TextWidget(
                                    'App Theme: ',
                                    fontSize: 16,
                                    weight: FontWeight.bold,
                                  ),
                                  TextWidget(
                                    context.read<ThemeBloc>().state.isBlueMode
                                        ? 'Blue'
                                        : 'Pink',
                                    fontSize: 16,
                                    weight: FontWeight.bold,
                                    color: AppColor.primary,
                                  ),
                                ],
                              ),
                              CustomSwitchButton(
                                value:
                                    context.read<ThemeBloc>().state.isBlueMode,
                                onChanged: (value) {
                                  context.read<ThemeBloc>().add(
                                    UpdateThemeEvent(isBlueMode: value),
                                  );
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.argument.isMe) _buildLogoutButton(),
            ],
          ),
        );
      },
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
