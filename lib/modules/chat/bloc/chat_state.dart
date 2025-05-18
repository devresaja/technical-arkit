part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class SendChatLoadingState extends ChatState {}

class SendChatLoadedState extends ChatState {
  final String chatroomId;

  SendChatLoadedState(this.chatroomId);
}

class SendChatErrorState extends ChatState {
  final String error;

  SendChatErrorState(this.error);
}

class GetChatroomIdLoadingState extends ChatState {}

class GetChatroomIdLoadedState extends ChatState {
  final String? chatroomId;

  GetChatroomIdLoadedState(this.chatroomId);
}

class GetChatroomIdErrorState extends ChatState {
  final String error;

  GetChatroomIdErrorState(this.error);
}
