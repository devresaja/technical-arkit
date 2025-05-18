import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:technical_artkit/shared/model/user_data.dart';

class ChatMessage {
  final String id;
  final UserData sender;
  final String content;
  final DateTime? timestamp;
  final String type;
  final List<String> readBy;
  final List<String> participants;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    this.timestamp,
    required this.type,
    required this.readBy,
    required this.participants,
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
      type: json['type'] ?? 'text',
      readBy: List<String>.from(json['readBy'] ?? []),
      participants: List<String>.from(json['participants'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender.toJson(),
    'content': content,
    'timestamp': timestamp,
    'type': type,
    'readBy': readBy,
    'participants': participants,
  };

  bool get isRead =>
      participants.isNotEmpty &&
      participants.every((userId) => readBy.contains(userId));
}
