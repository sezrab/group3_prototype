import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider extends ChangeNotifier {
  int? _newsletterPeriod;
  String? _newsletterAddress;
  List<String> _interests = [];

  // get interests
  Future<List<String>> getInterests(String uid) async {
    if (_interests.isNotEmpty) {
      return _interests;
    }
    var interests = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.get('interests').cast<String>();
      } else {
        return <String>[];
      }
    });
    return interests;
  }

  // set interests
  Future<void> setInterests(String uid, List<String> interests) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'interests': interests});
    _interests = interests;
    notifyListeners();
  }

  Future<int> getNewsletterPeriod(String uid) async {
    if (_newsletterPeriod != null) {
      return _newsletterPeriod!;
    }
    var snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snap.data()!.containsKey('newsletterPeriod')) {
      _newsletterPeriod = snap.get('newsletterPeriod');
    } else {
      _newsletterPeriod = 7;
    }

    return _newsletterPeriod!;
  }

  Future<void> setArticleRead(String uid, int articleId) async {
    // add it to the list of read articles
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'readArticles': FieldValue.arrayUnion([articleId])
    });
  }

  Future<List<int>> getReadArticles(String uid) async {
    var snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snap.data()!.containsKey('readArticles')) {
      return snap.get('readArticles').cast<int>();
    } else {
      return <int>[];
    }
  }

  Future<void> setNewsletterAddress(String uid, String address) async {
    // change uid -> settings doc -> newsletterAddress
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'newsletterAddress': address});
    _newsletterAddress = address;
  }

  Future<String> getNewsletterAddress(String uid) async {
    if (_newsletterAddress != null) {
      return _newsletterAddress!;
    }
    var snap =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (snap.data()!.containsKey('newsletterAddress')) {
      _newsletterAddress = snap.get('newsletterAddress');
    } else {
      _newsletterAddress = FirebaseAuth.instance.currentUser!.email!;
    }
    return _newsletterAddress!;
  }

  Future<void> setNewsletterPeriod(String uid, int period) async {
    // change uid -> settings doc -> newsletterPeriod
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'newsletterPeriod': period});
    _newsletterPeriod = period;
  }

  Future<void> setName(String uid, String name, {bool update = true}) async {
    if (update) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'name': name});
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'name': name});
    }
  }
}
