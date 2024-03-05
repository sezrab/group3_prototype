import 'package:flutter/material.dart';
import 'package:group3_prototype/models/article.dart';
import 'package:group3_prototype/reuse.dart/articleCard.dart';

class SearchResults extends StatelessWidget {
  final Future<List<ArticleData>> articles;
  final String query;
  const SearchResults({super.key, required this.articles, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for $query'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: FutureBuilder<List<ArticleData>>(
          future: articles,
          builder: (BuildContext context,
              AsyncSnapshot<List<ArticleData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ArticleCard(article: snapshot.data![index]);
                  },
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
