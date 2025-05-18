import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class ChatMessageItem extends StatelessWidget {
  final bool isMe;
  final String senderName;
  final String content;
  final DateTime timestamp;

  const ChatMessageItem({
    super.key,
    required this.isMe,
    required this.senderName,
    required this.content,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin:
                isMe
                    ? const EdgeInsets.only(top: 12, right: 8)
                    : const EdgeInsets.only(top: 12, left: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  senderName,
                  color: isMe ? AppColor.white : AppColor.black,
                  weight: FontWeight.bold,
                ),
                divide4,
                TextWidget(
                  content,
                  color: isMe ? AppColor.white : AppColor.black,
                ),
              ],
            ),
          ),
          Padding(
            padding:
                isMe
                    ? const EdgeInsets.only(right: 12, top: 4)
                    : const EdgeInsets.only(left: 12, top: 4),
            child: TextWidget(
              DateFormat.jm().format(timestamp),
              fontSize: 10,
              color: AppColor.black,
            ),
          ),
        ],
      ),
    );
  }
}
