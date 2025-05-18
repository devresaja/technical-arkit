import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
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
    final rawLast = json['last_message_time'];
    final rawCreate = json['created_at'];

    return ChatRoom(
      id: json['id'] ?? '',
      lastMessage: json['last_message'] ?? '',
      lastMessageTime:
          rawLast is DateTime
              ? rawLast
              : rawLast is Timestamp
              ? rawLast.toDate()
              : null,
      createdAt:
          rawCreate is DateTime
              ? rawCreate
              : rawCreate is Timestamp
              ? rawCreate.toDate()
              : null,
      otherUser: UserData.fromJson(json['other_user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'last_message': lastMessage,
    'last_message_time': lastMessageTime,
    'created_at': createdAt,
    'other_user': otherUser.toJson(),
  };
}
