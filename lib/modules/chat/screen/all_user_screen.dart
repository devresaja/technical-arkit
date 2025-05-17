import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/chat/bloc/chat_bloc.dart';
import 'package:technical_artkit/modules/chat/screen/chat_detail_screen.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/widget/image/cached_image.dart';
import 'package:technical_artkit/widget/page/view_handler_widget.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class AllUserScreen extends StatefulWidget {
  const AllUserScreen({super.key});

  static const String routeName = '/all-user-screen';

  @override
  State<AllUserScreen> createState() => _AllUserScreenState();
}

class _AllUserScreenState extends State<AllUserScreen> {
  final _chatBloc = ChatBloc();

  _getBloc() {
    _chatBloc.add(
      GetAllUsersEvent(currentUserId: FirebaseAuth.instance.currentUser!.uid),
    );
  }

  @override
  void initState() {
    super.initState();
    _getBloc();
  }

  final _users = <UserData>[];

  ViewMode _viewMode = ViewMode.loading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextWidget('All Users')),
      body: BlocProvider(
        create: (context) => _chatBloc,
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is GetAllUsersLoadingState) {
              _viewMode = ViewMode.loading;
            } else if (state is GetAllUsersLoadedState) {
              _users.addAll(state.users);
              _viewMode = ViewMode.loaded;
            } else if (state is GetAllUsersErrorState) {
              _viewMode = ViewMode.error;
            }
          },
          builder: (context, state) {
            return ViewHandlerWidget(
              viewMode: _viewMode,
              onTapError: _getBloc,
              child: _buildView(),
            );
          },
        ),
      ),
    );
  }

  ListView _buildView() {
    return ListView.separated(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return InkWell(
          onTap: () {
            Navigator.pushNamed(
              context,
              ChatDetailScreen.path,
              arguments: ChatDetailArgument(otherUser: user),
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
                TextWidget(user.name),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 1,
          width: double.infinity,
          color: Colors.grey,
        );
      },
    );
  }
}
