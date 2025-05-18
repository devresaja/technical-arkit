import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/modules/chat/model/chatroom.dart';
import 'package:technical_artkit/modules/chat/screen/all_user_screen.dart';
import 'package:technical_artkit/modules/chat/screen/chat_detail_screen.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/image/cached_image.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class ChatScreen extends StatefulWidget {
  static const String path = '/chat';

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatBloc = ChatBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget('Chat')),
      body: BlocProvider(
        create: (context) => _chatBloc,
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return _buildView();
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          backgroundColor: AppColor.primary,
          onPressed: () {
            Navigator.pushNamed(context, AllUserScreen.routeName);
          },
          child: Icon(Icons.message, color: AppColor.white),
        ),
      ),
    );
  }

  Widget _buildView() {
    return StreamBuilder<List<ChatRoom>>(
      stream: _chatBloc.streamChatrooms(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: TextWidget('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return buildCustomEmpty();
        }

        return _buildChatRooms(snapshot.data!);
      },
    );
  }

  Widget _buildChatRooms(List<ChatRoom> chatRooms) {
    return ListView.builder(
      itemCount: chatRooms.length,
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];

        if (chatRoom.lastMessageTime == null) {
          return Container();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatDetailScreen.path,
                arguments: ChatDetailArgument(
                  chatroomId: chatRoom.id,
                  otherUser: chatRoom.otherUser,
                ),
              );
            },
            child: Ink(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CachedImage(
                        key: Key(chatRoom.id),
                        imageUrl: chatRoom.otherUser.avatar,
                        isCircle: true,
                        height: 40,
                        width: 40,
                      ),
                      if (chatRoom.otherUser.isOnline)
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
                          chatRoom.otherUser.name,
                          color: AppColor.black,
                          fontSize: 16,
                          weight: FontWeight.bold,
                          maxLines: 1,
                          ellipsed: true,
                        ),
                        TextWidget(
                          chatRoom.lastMessage,
                          color: AppColor.black,
                          maxLines: 1,
                          ellipsed: true,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextWidget(
                      DateFormat.jm().format(chatRoom.lastMessageTime!),
                      fontSize: 10,
                      color: AppColor.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
