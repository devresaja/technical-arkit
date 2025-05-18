import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:technical_artkit/shared/model/user_data.dart';

class ChatMessage {
  final String id;
  final UserData sender;
  final String content;
  final DateTime? timestamp;
  final bool read;
  final String type;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    this.timestamp,
    required this.read,
    required this.type,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final raw = json['timestamp'];
    return ChatMessage(
      id: json['id'] ?? '',
      sender:
          json['sender'] != null
              ? UserData.fromJson(json['sender'])
              : UserData(
                userId: json['sender_id'] ?? '',
                name: '',
                email: '',
                avatar: null,
              ),
      content: json['content'] ?? '',
      timestamp:
          raw is DateTime
              ? raw
              : raw is Timestamp
              ? raw.toDate()
              : null,
      read: json['read'] ?? false,
      type: json['type'] ?? 'text',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender.toJson(),
    'content': content,
    'timestamp': timestamp,
    'read': read,
    'type': type,
  };
}
