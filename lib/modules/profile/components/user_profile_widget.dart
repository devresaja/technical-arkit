import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:technical_artkit/constant/divider.dart';
import 'package:technical_artkit/modules/profile/bloc/profile_bloc.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/utils/view_utils.dart';
import 'package:technical_artkit/widget/image/cached_image.dart';
import 'package:technical_artkit/widget/loading/blink.dart';
import 'package:technical_artkit/widget/text/text_widget.dart';

class UserProfileWidget extends StatefulWidget {
  final String userId;
  final bool showOnlineStatus;
  final double imageSize;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isVertical;
  final VoidCallback? onTap;

  const UserProfileWidget({
    super.key,
    required this.userId,
    this.showOnlineStatus = true,
    this.imageSize = 30,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.isVertical = false,
    this.onTap,
  });

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {
  final _profileBloc = ProfileBloc();
  late final StreamController<DateTime> _timeStreamController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeStreamController = StreamController<DateTime>.broadcast();
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
    return BlocProvider(
      create: (context) => _profileBloc,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: widget.isVertical ? 0 : 4),
          child: SizedBox(
            width:
                widget.isVertical
                    ? null
                    : MediaQuery.sizeOf(context).width * 0.6,
            child: StreamBuilder<UserData>(
              stream: _profileBloc.streamUserProfile(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return _buildLoadingWidget();
                }
                if (snapshot.hasError) {
                  return _buildErrorWidget(snapshot.error.toString());
                }
                if (!snapshot.hasData) {
                  return _buildEmptyWidget();
                }
                return StreamBuilder<DateTime>(
                  stream: _timeStreamController.stream,
                  builder: (context, timeSnapshot) {
                    return _buildUserProfileWidget(snapshot.data!);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    if (widget.isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Blink(
            height: widget.imageSize,
            width: widget.imageSize,
            isCircle: true,
          ),
          divide8,
          Column(
            children: [
              Blink(height: 12, width: 100, isRounded: true),
              divide6,
              Blink(height: 10, width: 80, isRounded: true),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        Blink(
          height: widget.imageSize,
          width: widget.imageSize,
          isCircle: true,
        ),
        divideW12,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Blink(height: 12, width: 100, isRounded: true),
            divide6,
            Blink(height: 10, width: 80, isRounded: true),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorWidget(String error) {
    if (widget.isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: widget.imageSize / 2,
            backgroundColor: Colors.grey[300],
            child: Icon(
              Icons.error,
              color: Colors.red,
              size: widget.imageSize * 0.6,
            ),
          ),
          divide8,
          TextWidget('Error loading profile', color: Colors.red, fontSize: 12),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        CircleAvatar(
          radius: widget.imageSize / 2,
          backgroundColor: Colors.grey[300],
          child: Icon(
            Icons.error,
            color: Colors.red,
            size: widget.imageSize * 0.6,
          ),
        ),
        divideW12,
        TextWidget('Error loading profile', color: Colors.red, fontSize: 12),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    if (widget.isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: widget.imageSize / 2,
            backgroundColor: Colors.grey[300],
            child: Icon(Icons.person, size: widget.imageSize * 0.6),
          ),
          divide8,
          TextWidget('User not found', fontSize: 12),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,

      children: [
        CircleAvatar(
          radius: widget.imageSize / 2,
          backgroundColor: Colors.grey[300],
          child: Icon(Icons.person, size: widget.imageSize * 0.6),
        ),
        divideW12,
        TextWidget('User not found', fontSize: 12),
      ],
    );
  }

  Widget _buildUserProfileWidget(UserData user) {
    if (widget.isVertical) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CachedImage(
              imageUrl: user.avatar,
              isCircle: true,
              height: widget.imageSize,
              width: widget.imageSize,
            ),
            divide8,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWidget(
                  user.name,
                  weight: widget.fontWeight,
                  fontSize: widget.fontSize,
                ),
                if (widget.showOnlineStatus)
                  TextWidget(
                    user.isOnline
                        ? 'Online'
                        : formatLastOnline(user.lastOnline),
                    fontSize: widget.fontSize - 2,
                    color: user.isOnline ? Colors.green : Colors.grey,
                  ),
              ],
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CachedImage(
          imageUrl: user.avatar,
          isCircle: true,
          height: widget.imageSize,
          width: widget.imageSize,
        ),
        divideW12,
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                user.name,
                maxLines: 1,
                ellipsed: true,
                weight: widget.fontWeight,
                fontSize: widget.fontSize,
              ),
              if (widget.showOnlineStatus)
                TextWidget(
                  user.isOnline ? 'Online' : formatLastOnline(user.lastOnline),
                  fontSize: widget.fontSize - 2,
                  color: user.isOnline ? Colors.green : Colors.grey,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
