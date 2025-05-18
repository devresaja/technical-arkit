import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/core/theme/app_color.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';
import 'package:technical_artkit/modules/chat/widget/chat_user_item.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  static const String routeName = '/all-user-screen';

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final _chatBloc = ChatBloc();

  final StreamController<DateTime> _timeStreamController =
      StreamController<DateTime>.broadcast();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_timeStreamController.isClosed) {
        _timeStreamController.add(DateTime.now());
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Users'), titleSpacing: 0),
      body: BlocProvider(create: (context) => _chatBloc, child: _buildView()),
    );
  }

  Widget _buildView() {
    return StreamBuilder<List<UserData>>(
      stream: _chatBloc.streamAllUsers(FirebaseAuth.instance.currentUser!.uid),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting &&
            !userSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userSnapshot.hasError) {
          return Center(child: TextWidget('Error: ${userSnapshot.error}'));
        }

        if (!userSnapshot.hasData || userSnapshot.data!.isEmpty) {
          return buildCustomEmpty();
        }

        return StreamBuilder<DateTime>(
          stream: _timeStreamController.stream,
          builder: (context, timeSnapshot) {
            return _buildUserGroups(userSnapshot.data!);
          },
        );
      },
    );
  }

  Widget _buildUserGroups(List<UserData> users) {
    final onlineUsers = users.where((user) => user.isOnline).toList();
    final offlineUsers = users.where((user) => !user.isOnline).toList();

    return ListView(
      children: [
        // Online users section
        if (onlineUsers.isNotEmpty) ...[
          _buildGroupHeader('Online Users'),
          ...onlineUsers.map((user) => ChatUserItem(user: user)),
        ],

        // Offline users section
        if (offlineUsers.isNotEmpty) ...[
          _buildGroupHeader('Offline Users'),
          ...offlineUsers.map((user) => ChatUserItem(user: user)),
        ],
      ],
    );
  }

  Widget _buildGroupHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: TextWidget(
        title,
        fontSize: 18,
        weight: FontWeight.bold,
        color: AppColor.black,
      ),
    );
  }
}
