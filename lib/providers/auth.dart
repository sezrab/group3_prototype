import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAuthProvider with ChangeNotifier {
  // FirebaseUser user;
  StreamSubscription? userAuthSub;
  User? user;
  String get uid => user!.uid;
  MyAuthProvider() : userAuthSub = null {
    userAuthSub = FirebaseAuth.instance.authStateChanges().listen(
      (newUser) {
        print('Auth state changed. User is: $newUser');
        user = newUser;
        notifyListeners();
      },
      onError: (e) {
        print('!!! auth.dart/userAuthSub error: $e');
        throw e;
      },
    );
  }

  @override
  void dispose() {
    try {
      userAuthSub!.cancel();
    } catch (e) {
      print(
          'auth.dart/dispose() error: userAuthSub is null. This is probably fine.');
    }
    super.dispose();
  }

  bool get isAnonymous {
    assert(user != null);
    bool isAnonymousUser = true;
    for (UserInfo info in user!.providerData) {
      if (info.providerId == "facebook.com" ||
          info.providerId == "google.com" ||
          info.providerId == "password") {
        isAnonymousUser = false;
        break;
      }
    }
    return isAnonymousUser;
  }

  bool get isAuthenticated {
    return user != null;
  }

  Future<void> registerWithPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    user = null;
  }
}
