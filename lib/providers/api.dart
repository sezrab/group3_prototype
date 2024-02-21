import 'dart:async';
import 'package:group3_prototype/models/article.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:group3_prototype/pages/article.dart';
import 'dart:convert';

class APIProvider extends ChangeNotifier {
  String api_url = 'http://localhost:5000/';

  List<ArticleData> feed = [];

  Future<List<ArticleData>> getFeed() async {
    if (feed.isEmpty) {
      await requestFeed(FirebaseAuth.instance.currentUser!.uid);
    }
    return feed;
  }

  Future<void> requestFeed(String userID) async {
    var requestURL = Uri.parse('${api_url}getFeed?userID=$userID');
    var response = await get(requestURL);
    if (response.statusCode == 200) {
      // parse response.body as JSON
      var data = jsonDecode(response.body);
      // create a list of ArticlePage objects from the JSON
      feed = [];
      for (var article in data) {
        feed.add(ArticleData.fromJson(article));
      }
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
