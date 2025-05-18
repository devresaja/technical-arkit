import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/widget/image/cached_image.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class ChatRoomItem extends StatelessWidget {
  final String chatRoomId;
  final String? avatarUrl;
  final bool isOnline;
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;
  final VoidCallback onTap;

  const ChatRoomItem({
    super.key,
    required this.chatRoomId,
    required this.avatarUrl,
    required this.isOnline,
    required this.name,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeIn,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Stack(
                  children: [
                    CachedImage(
                      key: Key(chatRoomId),
                      imageUrl: avatarUrl,
                      isCircle: true,
                      height: 40,
                      width: 40,
                    ),
                    if (isOnline)
                      Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ),
                  ],
                ),
                divideW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget(
                        name,
                        color: AppColor.black,
                        fontSize: 16,
                        weight: FontWeight.bold,
                        maxLines: 1,
                        ellipsed: true,
                      ),
                      TextWidget(
                        lastMessage,
                        color: AppColor.black,
                        maxLines: 1,
                        ellipsed: true,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    TextWidget(
                      DateFormat.jm().format(lastMessageTime),
                      fontSize: 10,
                      color: AppColor.black,
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
