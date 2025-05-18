import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String userId;
  final String name;
  final String email;
  final String? avatar;
  final bool isOnline;
  final DateTime? lastOnline;

  UserData({
    required this.userId,
    required this.name,
    required this.email,
    required this.avatar,
    this.isOnline = false,
    this.lastOnline,
  });

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'name': name,
    'email': email,
    'avatar': avatar,
    'is_online': isOnline,
    'last_online': lastOnline,
  };

  factory UserData.fromJson(Map<String, dynamic> map) {
    final raw = map['last_online'];
    return UserData(
      userId: map['user_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'],
      isOnline: map['is_online'] as bool? ?? false,
      lastOnline:
          raw is DateTime
              ? raw
              : raw is Timestamp
              ? raw.toDate()
              : null,
    );
  }

  UserData copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatar,
    bool? isOnline,
    DateTime? lastOnline,
  }) => UserData(
    userId: userId ?? this.userId,
    name: name ?? this.name,
    email: email ?? this.email,
    avatar: avatar ?? this.avatar,
    isOnline: isOnline ?? this.isOnline,
    lastOnline: lastOnline ?? this.lastOnline,
  );
}
