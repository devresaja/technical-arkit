part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

class ChatInitial extends ChatState {}

class GetAllUsersLoadingState extends ChatState {}

class GetAllUsersLoadedState extends ChatState {
  final List<UserData> users;

  GetAllUsersLoadedState(this.users);
}

class GetAllUsersErrorState extends ChatState {
  final String error;

  GetAllUsersErrorState(this.error);
}

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
