import 'package:flutter/material.dart';
import 'package:group3_prototype/models/article.dart';
import 'package:group3_prototype/pages/article.dart';

class ArticleCard extends StatelessWidget {
  final ArticleData article;
  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    String shortDescription = article.abstract.substring(0, 100);
    if (article.abstract.length > 100) {
      shortDescription += '...';
    }

    return GestureDetector(
      onTap: () {
        var a = ArticlePage(article: article);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => a),
        );
      },
      child: Card(
        // background color white
        // on tap, go to article page
        color: Colors.white,
        // grey border
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade300, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                article.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                // join authors with commas
                article.authors.join(', '),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(shortDescription,
                  style: TextStyle(fontStyle: FontStyle.italic)),
              Row(
                children: [
                  IconButton(
                      onPressed: () {}, icon: Icon(Icons.bookmark_border)),
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Spacer(),
                            for (String tag in article.tags.take(3))
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  tag,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
