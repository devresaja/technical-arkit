part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}

class SendChatEvent extends ChatEvent {
  final String? chatroomId;
  final String currentUserId;
  final String otherUserId;
  final String content;

  SendChatEvent({
    this.chatroomId,
    required this.currentUserId,
    required this.otherUserId,
    required this.content,
  });
}

class GetChatroomIdEvent extends ChatEvent {
  final String currentUserId;
  final String otherUserId;

  GetChatroomIdEvent({required this.currentUserId, required this.otherUserId});
}
