import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/modules/chat/model/chat_message.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';
import 'package:technical_artkit/modules/profile/screen/profile_screen.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/page/view_handler_widget.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:technical_artkit/modules/chat/widget/chat_message_item.dart';

class ChatDetailArgument {
  final String? chatroomId;
  final String otherUserId;

  ChatDetailArgument({this.chatroomId, required this.otherUserId});
}

class ChatDetailScreen extends StatefulWidget {
  final ChatDetailArgument argument;

  static const String path = '/chat-detail';

  const ChatDetailScreen({super.key, required this.argument});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final _currentUserId = FirebaseAuth.instance.currentUser!.uid;
  final _chatController = TextEditingController();
  final _chatBloc = ChatBloc();
  String? _chatroomId;

  _getChatroomId() {
    if (widget.argument.chatroomId != null) {
      _chatroomId = widget.argument.chatroomId;
      _viewMode = ViewMode.loaded;
    } else {
      _chatBloc.add(
        GetChatroomIdEvent(
          currentUserId: _currentUserId,
          otherUserId: widget.argument.otherUserId,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getChatroomId();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  ViewMode _viewMode = ViewMode.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: UserProfileWidget(
          userId: widget.argument.otherUserId,
          imageSize: 30,
          fontWeight: FontWeight.w500,
          titleColor: AppColor.white,
          onlineStatusColor: AppColor.white,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProfileScreen.path,
              arguments: ProfileArgument(userId: widget.argument.otherUserId),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocProvider(
              create: (context) => _chatBloc,
              child: BlocConsumer<ChatBloc, ChatState>(
                listener: (context, state) {
                  // Get chatroom id
                  if (state is GetChatroomIdLoadedState) {
                    _chatroomId = state.chatroomId;
                    _viewMode = ViewMode.loaded;
                  } else if (state is GetChatroomIdErrorState) {
                    showCustomSnackBar(state.error);
                    _viewMode = ViewMode.error;
                  }
                  // Send chat
                  else if (state is SendChatLoadedState) {
                    _chatroomId = state.chatroomId;
                  } else if (state is SendChatErrorState) {
                    showCustomSnackBar(state.error);
                  }
                },
                builder: (context, state) {
                  return ViewHandlerWidget(
                    viewMode: _viewMode,
                    child: _buildView(),
                  );
                },
              ),
            ),
          ),
          _buildTextField(),
        ],
      ),
    );
  }

  Widget _buildView() {
    if (_chatroomId == null) {
      return buildCustomEmpty();
    }

    return StreamBuilder<List<ChatMessage>>(
      stream: _chatBloc.streamChatMessage(_chatroomId!, _currentUserId),
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

        return _buildMessageList(snapshot.data!);
      },
    );
  }

  ListView _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      reverse: true,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];

        final isMe = message.sender.userId == _currentUserId;

        if (message.timestamp == null) {
          return Container();
        }

        return ChatMessageItem(
          isMe: isMe,
          senderName: message.sender.name,
          content: message.content,
          timestamp: message.timestamp!,
          isRead: message.isRead,
        );
      },
    );
  }

  Padding _buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _chatController,
              style: TextStyle(color: AppColor.black),
              decoration: InputDecoration(hintText: 'Type a message'),
            ),
          ),
          divideW12,
          IconButton(
            icon: Icon(Icons.send, color: AppColor.primary),
            iconSize: 30,
            onPressed: () {
              if (_chatController.text.trim().isNotEmpty) {
                _chatBloc.add(
                  SendChatEvent(
                    chatroomId: _chatroomId,
                    currentUserId: _currentUserId,
                    otherUserId: widget.argument.otherUserId,
                    content: _chatController.text,
                  ),
                );
                _chatController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
