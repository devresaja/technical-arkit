import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

class ChatRoom {
  final String id;
  final String lastMessage;
  final DateTime? lastMessageTime;
  final DateTime? createdAt;
  final UserData otherUser;

  ChatRoom({
    required this.id,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    required this.otherUser,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: (json['last_message_time'] as Timestamp?)?.toDate(),
      createdAt: (json['created_at'] as Timestamp?)?.toDate(),
      otherUser: UserData.fromJson(json['other_user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
      'created_at': createdAt,
      'other_user': otherUser.toJson(),
    };
  }
}
