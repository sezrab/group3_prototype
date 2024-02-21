import 'package:flutter/material.dart';
import 'package:group3_prototype/models/article.dart';
import 'package:group3_prototype/pages/article.dart';
import 'package:group3_prototype/providers/api.dart';
import 'package:provider/provider.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    // get the feed from the API
    Future<List<ArticleData>> feed =
        Provider.of<APIProvider>(context).getFeed();
    return FutureBuilder(
        future: feed,
        builder:
            (BuildContext context, AsyncSnapshot<List<ArticleData>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(':(', style: Theme.of(context).textTheme.titleLarge),
                  Text('something went wrong',
                      style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {});
                        },
                        child: Text('Retry'),
                      ),
                      ElevatedButton(
                        child: Text('More info'),
                        onPressed: () {
                          // show dialog with error message and stack trace
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Text('Something went wrong'),
                                      Text(snapshot.error.toString()),
                                      Text(snapshot.stackTrace.toString()),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Close'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyMedium,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              // color grey,
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height:
                          50.0, // Assuming this is the height of the search bar

                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey,
                            width:
                                1.0), // Assuming this is the border style of the search bar
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment
                          .center, // This will center the DropdownButton vertically
                      child: DropdownButtonHideUnderline(
                        // This is to remove the default underline of the DropdownButton
                        child: DropdownButton<String>(
                          style: Theme.of(context).textTheme.bodyMedium,

                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          isExpanded:
                              false, // This is to make the DropdownButton take the full width of the Container
                          value: 'Relevance',
                          onChanged: (String? value) {},
                          items: const [
                            DropdownMenuItem(
                              value: 'Relevance',
                              child: Text('Relevance'),
                            ),
                            DropdownMenuItem(
                              value: 'Newest',
                              child: Text('Date (newest)'),
                            ),
                            DropdownMenuItem(
                              value: 'Oldest',
                              child: Text('Date (oldest)'),
                            ),
                            DropdownMenuItem(
                              value: 'Topic',
                              child: Text('Topic'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ArticleCard(article: snapshot.data![index]);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}

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
                      onPressed: () {}, icon: Icon(Icons.favorite_border)),
                  Expanded(
                    child: SingleChildScrollView(
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Spacer(),
                            for (String tag in article.tags)
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
