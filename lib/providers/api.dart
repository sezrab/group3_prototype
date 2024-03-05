import 'dart:async';
import 'package:group3_prototype/models/article.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class APIProvider extends ChangeNotifier {
  String api_url = 'http://localhost:5000/';
  List<ArticleData> feed = [];
  void setAPIURL(String url) {
    api_url = url;
    notifyListeners();
  }

  String getAPIURL() {
    return api_url;
  }

  Future<List<String>> getTopics() async {
    var requestURL = Uri.parse('${api_url}allTopics');
    var response = await get(requestURL);
    if (response.statusCode == 200) {
      // parse response.body as JSON
      var data = jsonDecode(response.body);
      // create a list of ArticlePage objects from the JSON
      return data.cast<String>();
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<List<ArticleData>> search(String query) async {
    var requestURL = Uri.parse('${api_url}search?q=$query');
    var response = await get(requestURL);
    if (response.statusCode == 200) {
      // parse response.body as JSON
      var data = jsonDecode(response.body);
      // create a list of ArticlePage objects from the JSON using the ArticleData.fromJson method
      return data
          .map<ArticleData>((article) => ArticleData.fromJson(article))
          .toList();
    } else {
      throw Exception(response.statusCode);
    }
  }

  void sortBy(String sort, List<int> read) {
    if (sort == 'newest') {
      feed.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } else if (sort == 'oldest') {
      feed.sort((a, b) => a.publishedAt.compareTo(b.publishedAt));
    } else if (sort == 'relevance') {
      feed.sort((a, b) => a.relevance.compareTo(b.relevance));
    }

    for (var a in feed) {
      if (read.contains(a.id)) {
        a.read = true;
        // move a to the end of the list
        feed.remove(a);
        feed.add(a);
      }
    }

    notifyListeners();
  }

  Future<List<ArticleData>> getFeed({bool refresh = false}) async {
    if (refresh || feed.isEmpty) {
      await requestFeed(FirebaseAuth.instance.currentUser!.uid);
    }
    return feed;
  }

  Future<List<ArticleData>> sortAndGetFeed(String sort, List<int> read) async {
    sortBy(sort, read);
    return getFeed();
  }

  Future<void> requestFeed(String userID) async {
    var requestURL = Uri.parse('${api_url}getFeed?user_id=$userID');
    var response = await get(requestURL);
    if (response.statusCode == 200) {
      // parse response.body as JSON
      var data = jsonDecode(response.body);
      // create a list of ArticlePage objects from the JSON
      feed = [];
      int r = 0;
      for (var article in data) {
        var a = ArticleData.fromJson(article);
        a.relevance = r;
        feed.add(a);
        r++;
      }
      notifyListeners();
    } else {
      throw Exception(response.statusCode);
    }
  }
}
