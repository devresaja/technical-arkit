import 'package:flutter/material.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';

class ProfileArgument {
  final String userId;

  ProfileArgument({required this.userId});
}

class ProfileScreen extends StatelessWidget {
  final ProfileArgument argument;

  static const String path = '/profile';

  const ProfileScreen({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: UserProfileWidget(
                  userId: argument.userId,
                  imageSize: 120,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  isVertical: true,
                ),
              ),
              divide24,
            ],
          ),
        ),
      ),
    );
  }
}
