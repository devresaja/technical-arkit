import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:technical_artkit/shared/model/user_data.dart';

class ProfileApi {
  final _firestore = FirebaseFirestore.instance;

  Stream<UserData> streamUserById(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      if (!snapshot.exists) {
        throw Exception('User not found');
      }
      return UserData.fromJson(snapshot.data()!);
    });
  }
}
