import 'package:flutter/material.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/widget/button/custom_button.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class NotFoundScreen extends StatefulWidget {
  static const String path = '/not-found';
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget('Page Not Found'),
            divide24,
            CustomButton(
              text: 'Back',
              width: MediaQuery.of(context).size.width * 0.7,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
