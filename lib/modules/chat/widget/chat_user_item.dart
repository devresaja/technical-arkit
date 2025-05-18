import 'package:flutter/material.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/chat/screen/chat_detail_screen.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/image/cached_image.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class ChatUserItem extends StatelessWidget {
  final UserData user;

  const ChatUserItem({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatDetailScreen.path,
              arguments: ChatDetailArgument(otherUserId: user.userId),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                CachedImage(
                  imageUrl: user.avatar,
                  isCircle: true,
                  height: 40,
                  width: 40,
                ),
                divideW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(user.name, weight: FontWeight.bold),
                      divide6,
                      TextWidget(
                        user.isOnline
                            ? 'Online'
                            : 'Last online: ${formatLastOnline(user.lastOnline)}',
                        fontSize: 12,
                        color: user.isOnline ? Colors.green : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 1,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}
