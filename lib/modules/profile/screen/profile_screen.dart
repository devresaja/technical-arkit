import 'package:flutter/material.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

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
      appBar: AppBar(
        titleSpacing: 0,
        title: const TextWidget('Profile', weight: FontWeight.w600),
      ),
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
              _buildProfileDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return const Column(
      children: [
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget('About', weight: FontWeight.bold, fontSize: 16),
                divide12,
                TextWidget(
                  'User profile information will be displayed here.',
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),
        divide16,
        Card(
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  'Contact Information',
                  weight: FontWeight.bold,
                  fontSize: 16,
                ),
                divide12,
                Row(
                  children: [
                    Icon(Icons.email, size: 20),
                    divideW8,
                    TextWidget('user@example.com', fontSize: 14),
                  ],
                ),
                divide8,
                Row(
                  children: [
                    Icon(Icons.phone, size: 20),
                    divideW8,
                    TextWidget('+1234567890', fontSize: 14),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
