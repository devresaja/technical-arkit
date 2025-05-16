import 'package:flutter/material.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class CustomDivider extends StatelessWidget {
  final String? text;
  final double? textSpacing;
  final Color? color;
  final Color? textColor;

  const CustomDivider({
    super.key,
    this.text,
    this.textSpacing,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Flexible(
            child: Divider(thickness: 1, color: color ?? AppColor.primary),
          ),
          SizedBox(width: textSpacing),
          if (text != null)
            Padding(
              padding: EdgeInsets.only(left: 0.05, right: 0.05),
              child: TextWidget(text, color: AppColor.accent),
            ),
          SizedBox(width: textSpacing),
          Flexible(
            child: Divider(thickness: 1, color: color ?? AppColor.primary),
          ),
        ],
      ),
    );
  }
}
