import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/core/theme/bloc/theme_bloc.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/modules/chat/model/chatroom.dart';
import 'package:technical_artkit/modules/chat/screen/all_user_screen.dart';
import 'package:technical_artkit/modules/chat/screen/chat_detail_screen.dart';
import 'package:technical_artkit/modules/profile/screen/profile_screen.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:technical_artkit/modules/chat/widget/chat_room_item.dart';

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
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    ProfileScreen.path,
                    arguments: ProfileArgument(
                      userId: FirebaseAuth.instance.currentUser!.uid,
                      isMe: true,
                    ),
                  );
                },
                icon: Icon(Icons.account_circle, size: 28),
              ),
            ],
          ),
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
              child: Icon(Icons.message, color: Colors.white),
            ),
          ),
        );
      },
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

        return ChatRoomItem(
          chatRoomId: chatRoom.id,
          avatarUrl: chatRoom.otherUser.avatar,
          name: chatRoom.otherUser.name,
          lastMessage: chatRoom.lastMessage,
          lastMessageTime: chatRoom.lastMessageTime!,
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatDetailScreen.path,
              arguments: ChatDetailArgument(
                chatroomId: chatRoom.id,
                otherUserId: chatRoom.otherUser.userId,
              ),
            );
          },
        );
      },
    );
  }
}
