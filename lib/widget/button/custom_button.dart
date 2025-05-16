import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final String? imagePath;
  final double borderRadius;
  final bool isLoading;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final double? fontSize;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.imagePath,
    this.borderRadius = 30.0,
    this.isLoading = false,
    this.color,
    this.borderColor,
    this.textColor,
    this.fontSize,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: color ?? AppColor.primary,
          side: BorderSide(color: borderColor ?? Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child:
            isLoading
                ? loading(size: 24)
                : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imagePath != null)
                      Image.asset(imagePath!, height: 24.0),
                    TextWidget(
                      text,
                      color: textColor ?? AppColor.white,
                      fontSize: fontSize,
                    ),
                  ],
                ),
      ),
    );
  }
}
