import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:technical_artkit/services/local_storage_service.dart';
import 'package:technical_artkit/shared/model/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthApi {
  Future<Either<String, bool>> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await LocalStorageService.removeValue();
      return Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String?, UserData>> loginByGoogle() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      final GoogleSignInAccount? gUser =
          await GoogleSignIn(
            serverClientId:
                '285255528528-6ba032blgdvlgv8kkmnt1r8eqmnna03e.apps.googleusercontent.com',
          ).signIn();

      if (gUser == null) {
        return Left(null);
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final data = await FirebaseAuth.instance.signInWithCredential(credential);

      final userData = UserData(
        userId: data.user!.uid,
        name: data.user!.displayName ?? '-',
        email: data.user!.email ?? '-',
        avatar: data.user!.photoURL,
      );

      await LocalStorageService.setUserData(userData);

      return Right(userData);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, bool>> updateUserData(
    String userId,
    Map<String, dynamic> data,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data);
      return Right(true);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
