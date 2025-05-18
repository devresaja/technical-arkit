import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AppLifecycleService with WidgetsBindingObserver {
  static final AppLifecycleService instance = AppLifecycleService._internal();

  AppLifecycleService._internal();

  bool _isAppInBackground = false;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    _handleAppLifecycleChange(state);
  }

  Future<void> _handleAppLifecycleChange(AppLifecycleState state) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    switch (state) {
      case AppLifecycleState.resumed:
        if (_isAppInBackground) {
          await _updateOnlineStatus(user.uid, true);
          _isAppInBackground = false;
        }
        break;

      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _isAppInBackground = true;
        await _updateOnlineStatus(user.uid, false);
        break;

      default:
    }
  }

  Future<void> _updateOnlineStatus(String userId, bool isOnline) async {
    try {
      final updateData = <String, dynamic>{'is_online': isOnline};

      if (!isOnline) {
        updateData['last_online'] = FieldValue.serverTimestamp();
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updateData);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
