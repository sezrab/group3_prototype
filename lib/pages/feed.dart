import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3_prototype/models/article.dart';
import 'package:group3_prototype/pages/article.dart';
import 'package:group3_prototype/providers/api.dart';
import 'package:group3_prototype/providers/firestore.dart';
import 'package:group3_prototype/reuse.dart/articleCard.dart';
import 'package:provider/provider.dart';

import 'searchResults.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  String selected = 'relevance';
  @override
  Widget build(BuildContext context) {
    Future<List<ArticleData>> feed = Provider.of<FirestoreProvider>(context)
        .getReadArticles(FirebaseAuth.instance.currentUser!.uid)
        .then((readArticles) {
      // get the feed from the API
      return Provider.of<APIProvider>(context, listen: false)
          .sortAndGetFeed(selected, readArticles);
    });

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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {});
                            },
                            child: Text('Retry'),
                          ),
                          SizedBox(width: 8),
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
                      ElevatedButton(
                          onPressed: () {
                            var t = TextEditingController(
                                text: Provider.of<APIProvider>(context,
                                        listen: false)
                                    .getAPIURL());
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Server URL'),
                                  content: TextField(
                                    controller: t,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Save'),
                                      onPressed: () {
                                        Provider.of<APIProvider>(context,
                                                listen: false)
                                            .setAPIURL(t.text);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text("Edit server URL"))
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
                          textInputAction: TextInputAction.go,
                          onSubmitted: (String value) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SearchResults(
                                articles: Provider.of<APIProvider>(context,
                                        listen: false)
                                    .search(value),
                                query: value,
                              );
                            }));
                          },
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
                          value: selected,
                          onChanged: (String? value) async {
                            var uid = FirebaseAuth.instance.currentUser!.uid;
                            Provider.of<FirestoreProvider>(context,
                                    listen: false)
                                .getReadArticles(uid)
                                .then((read) {
                              Provider.of<APIProvider>(context, listen: false)
                                  .sortBy(value!, read);
                            });
                            setState(() {
                              selected = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'relevance',
                              child: Text('Relevance'),
                            ),
                            DropdownMenuItem(
                              value: 'newest',
                              child: Text('Date (newest)'),
                            ),
                            DropdownMenuItem(
                              value: 'oldest',
                              child: Text('Date (oldest)'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      Provider.of<APIProvider>(context, listen: false)
                          .getFeed(refresh: true);
                    },
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleCard(article: snapshot.data![index]);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
