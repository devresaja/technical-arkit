import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:technical_artkit/modules/chat/model/chatroom.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:technical_artkit/modules/chat/model/chat_message.dart';

class ChatApi {
  final _firestore = FirebaseFirestore.instance;

  Future<Either<String, List<UserData>>> getAllUsers(
    String currentUserId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('users')
              .where(FieldPath.documentId, isNotEqualTo: currentUserId)
              .get();

      final List<UserData> users =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return UserData.fromJson(data);
          }).toList();

      return Right(users);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Stream<List<UserData>> streamAllUsers(String currentUserId) {
    return _firestore
        .collection('users')
        .where(FieldPath.documentId, isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return UserData.fromJson(data);
          }).toList();
        });
  }

  Future<Either<String, String?>> getChatroomId(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('chatrooms')
              .where('participants', arrayContains: currentUserId)
              .get();

      for (var doc in querySnapshot.docs) {
        final List<dynamic> participants = doc.data()['participants'];
        if (participants.contains(otherUserId)) {
          return Right(doc.id);
        }
      }

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Stream<List<ChatMessage>> streamChatMessages({
    required String chatroomId,
    required String currentUserId,
  }) {
    final messagesRef = _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true);

    return messagesRef.snapshots().map((snapshot) {
      final messages =
          snapshot.docs.map((doc) {
            final data = doc.data();

            data['id'] = doc.id;

            final chatMessage = ChatMessage.fromJson(data);

            _markMessageAsRead(chatroomId, doc.id, currentUserId);

            return chatMessage;
          }).toList();

      return messages;
    });
  }

  Future<Either<String, void>> markMessagesAsRead(
    String chatroomId,
    String currentUserId,
  ) async {
    try {
      final messagesRef = _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .collection('messages');

      final querySnapshot =
          await messagesRef
              .where('sender_id', isNotEqualTo: currentUserId)
              .get();

      final batch = _firestore.batch();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final List<dynamic> readBy = List<dynamic>.from(data['readBy'] ?? []);

        if (!readBy.contains(currentUserId)) {
          readBy.add(currentUserId);
          batch.update(doc.reference, {'readBy': readBy});
          log('masuk mark');
        }
      }

      await batch.commit();

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<void> _markMessageAsRead(
    String chatroomId,
    String messageId,
    String userId,
  ) async {
    final messageRef = _firestore
        .collection('chatrooms')
        .doc(chatroomId)
        .collection('messages')
        .doc(messageId);

    final doc = await messageRef.get();
    if (!doc.exists) return;

    final data = doc.data()!;
    final List<dynamic> readBy = List<dynamic>.from(data['readBy'] ?? []);

    if (!readBy.contains(userId)) {
      readBy.add(userId);
      await messageRef.update({'readBy': readBy});
    }
  }

  Stream<List<ChatRoom>> streamChatrooms(String userId) {
    return _firestore
        .collection('chatrooms')
        .where('participants', arrayContains: userId)
        .snapshots()
        .asyncMap((snapshot) async {
          final List<ChatRoom> rooms = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final List<dynamic> participants = data['participants'] ?? [];

            final otherUserId = participants.firstWhere(
              (id) => id != userId,
              orElse: () => '',
            );

            if (otherUserId.isEmpty) continue;

            final userResult = await _getUserById(otherUserId);
            if (userResult.isLeft) continue;

            final userData = userResult.right.toJson();

            final chatRoom = ChatRoom.fromJson({
              ...data,
              'other_user': userData,
            });

            rooms.add(chatRoom);
          }

          rooms.sort((a, b) {
            if (a.lastMessageTime == null) return 1;
            if (b.lastMessageTime == null) return -1;
            return b.lastMessageTime!.compareTo(a.lastMessageTime!);
          });

          return rooms;
        });
  }

  Future<Either<String, String>> sendChat(
    String? chatroomId,
    String currentUserId,
    String otherUserId,
    String content,
  ) async {
    try {
      String chatId;

      if (chatroomId == null) {
        final createResult = await _createChatroom(currentUserId, otherUserId);
        if (createResult.isLeft) {
          return Left(createResult.left);
        }
        chatId = createResult.right;
      } else {
        chatId = chatroomId;
      }

      final sendResult = await _sendMessage(chatId, currentUserId, content);
      if (sendResult.isLeft) {
        return Left(sendResult.left);
      }

      return Right(chatId);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> _createChatroom(
    String currentUserId,
    String otherUserId,
  ) async {
    try {
      final chatroomId = _firestore.collection('chatrooms').doc().id;

      await _firestore.collection('chatrooms').doc(chatroomId).set({
        'id': chatroomId,
        'created_at': FieldValue.serverTimestamp(),
        'last_message': '',
        'last_message_time': FieldValue.serverTimestamp(),
        'participants': [currentUserId, otherUserId],
      });

      return Right(chatroomId);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> _sendMessage(
    String chatroomId,
    String senderId,
    String content,
  ) async {
    try {
      final userResult = await _getUserById(senderId);
      if (userResult.isLeft) {
        return Left(userResult.left);
      }

      final userData = userResult.right;

      // Get chatroom to get participants
      final chatroomDoc =
          await _firestore.collection('chatrooms').doc(chatroomId).get();
      final List<String> participants = List<String>.from(
        chatroomDoc.data()?['participants'] ?? [],
      );

      final messageRef = _firestore
          .collection('chatrooms')
          .doc(chatroomId)
          .collection('messages');

      await messageRef.add({
        'sender': userData.toJson(),
        'sender_id': senderId,
        'content': content,
        'timestamp': FieldValue.serverTimestamp(),
        'read': false,
        'type': 'text',
        'readBy': [senderId], // Sender has read their own message
        'participants': participants,
      });

      final updateResult = await _updateChatroom(chatroomId, content);
      if (updateResult.isLeft) {
        return Left(updateResult.left);
      }

      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> _updateChatroom(
    String chatroomId,
    String lastMessage,
  ) async {
    try {
      await _firestore.collection('chatrooms').doc(chatroomId).update({
        'last_message': lastMessage,
        'last_message_time': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, UserData>> _getUserById(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return Left('User not found');
      }

      final userData = UserData.fromJson(userDoc.data()!);
      return Right(userData);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
