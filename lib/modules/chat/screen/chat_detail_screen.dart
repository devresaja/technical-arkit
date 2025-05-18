import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/modules/chat/model/chat_message.dart';
import 'package:technical_artkit/modules/profile/components/user_profile_widget.dart';
import 'package:technical_artkit/modules/profile/screen/profile_screen.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/page/view_handler_widget.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:intl/intl.dart';

class ChatDetailArgument {
  final String? chatroomId;
  final UserData otherUser;

  ChatDetailArgument({this.chatroomId, required this.otherUser});
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
          otherUserId: widget.argument.otherUser.userId,
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
          userId: widget.argument.otherUser.userId,
          imageSize: 30,
          fontWeight: FontWeight.w500,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProfileScreen.path,
              arguments: ProfileArgument(
                userId: widget.argument.otherUser.userId,
              ),
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
      stream: _chatBloc.streamChatMessage(_chatroomId!),
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
                      message.sender.name,
                      color: isMe ? AppColor.white : AppColor.black,
                      weight: FontWeight.bold,
                    ),
                    divide4,
                    TextWidget(
                      message.content,
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
                  DateFormat.jm().format(message.timestamp!),
                  fontSize: 10,
                  color: AppColor.black,
                ),
              ),
            ],
          ),
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
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
                    otherUserId: widget.argument.otherUser.userId,
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
