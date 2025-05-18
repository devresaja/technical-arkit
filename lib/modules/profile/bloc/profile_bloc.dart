import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:technical_artkit/modules/profile/data/profile_api.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _api = ProfileApi();

  ProfileBloc() : super(ProfileInitial());

  StreamController<UserData> streamUserProfile(String userId) {
    final controller = StreamController<UserData>();
    _api.streamUserById(userId).listen((userData) {
      controller.add(userData);
    });
    return controller;
  }
}
