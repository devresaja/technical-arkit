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

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'user_id': userId,
      'name': name,
      'email': email,
      'avatar': avatar,
      'is_online': isOnline,
      'last_online': lastOnline,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> map) {
    return UserData(
      userId: map['user_id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      avatar: map['avatar'] as String?,
      isOnline: map['is_online'] as bool? ?? false,
      lastOnline: (map['last_online'] as Timestamp?)?.toDate(),
    );
  }

  @override
  bool operator ==(covariant UserData other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar &&
        other.isOnline == isOnline &&
        other.lastOnline == lastOnline;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        name.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        isOnline.hashCode ^
        lastOnline.hashCode;
  }

  UserData copyWith({
    String? userId,
    String? name,
    String? email,
    String? avatar,
    bool? isOnline,
    dynamic lastOnline,
  }) {
    return UserData(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      isOnline: isOnline ?? this.isOnline,
      lastOnline: lastOnline ?? this.lastOnline,
    );
  }
}
