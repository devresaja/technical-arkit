import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:technical_artkit/modules/chat/data/chat_api.dart';
import 'package:technical_artkit/modules/chat/model/chat_message.dart';
import 'package:technical_artkit/modules/chat/model/chatroom.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final _api = ChatApi();

  ChatBloc() : super(ChatInitial()) {
    on<SendChatEvent>(_sendChat);
    on<GetChatroomIdEvent>(_getChatroomId);
  }

  Stream<List<ChatRoom>> streamChatrooms(String userId) {
    return _api.streamChatrooms(userId);
  }

  StreamController<List<UserData>> streamAllUsers(String currentUserId) {
    final controller = StreamController<List<UserData>>();
    _api.streamAllUsers(currentUserId).listen((users) {
      controller.add(users);
    });
    return controller;
  }

  _getChatroomId(GetChatroomIdEvent event, Emitter<ChatState> emit) async {
    emit(GetChatroomIdLoadingState());

    try {
      final response = await _api.getChatroomId(
        event.currentUserId,
        event.otherUserId,
      );

      response.fold(
        (error) => emit(GetChatroomIdErrorState(error)),
        (chatroomId) => emit(GetChatroomIdLoadedState(chatroomId)),
      );
    } catch (e) {
      emit(GetChatroomIdErrorState(e.toString()));
    }
  }

  Stream<List<ChatMessage>> streamChatMessage(String chatroomId) {
    return _api.streamChatMessages(chatroomId);
  }

  _sendChat(SendChatEvent event, Emitter<ChatState> emit) async {
    emit(SendChatLoadingState());

    try {
      final response = await _api.sendChat(
        event.chatroomId,
        event.currentUserId,
        event.otherUserId,
        event.content,
      );

      response.fold(
        (error) => emit(SendChatErrorState(error)),
        (chatroomId) => emit(SendChatLoadedState(chatroomId)),
      );
    } catch (e) {
      emit(SendChatErrorState(e.toString()));
    }
  }
}
