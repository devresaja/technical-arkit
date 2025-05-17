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
    on<GetAllUsersEvent>(_getAllUsers);
    on<SendChatEvent>(_sendChat);
    on<GetChatroomIdEvent>(_getChatroomId);
  }

  Stream<List<ChatRoom>> streamChatrooms(String userId) {
    return _api.streamChatrooms(userId);
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

  _getAllUsers(GetAllUsersEvent event, Emitter<ChatState> emit) async {
    emit(GetAllUsersLoadingState());

    try {
      final response = await _api.getAllUsers(event.currentUserId);

      response.fold(
        (error) => emit(GetAllUsersErrorState(error)),
        (users) => emit(GetAllUsersLoadedState(users)),
      );
    } catch (e) {
      emit(GetAllUsersErrorState(e.toString()));
    }
  }
}
