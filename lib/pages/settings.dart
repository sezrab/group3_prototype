import 'package:flutter/material.dart';
import 'package:group3_prototype/providers/api.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:group3_prototype/providers/firestore.dart';
import 'package:group3_prototype/reuse.dart/wideButton.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> _topics = [];
  List<String> _selected = [];
  int _period = 3;
  bool _newsletter = true;
  @override
  Widget build(BuildContext context) {
    // Get all the topics
    Future<List<String>> topicsFuture =
        Provider.of<APIProvider>(context, listen: true).getTopics();
    // Get interests
    Future<List<String>> userTopicsFuture =
        Provider.of<FirestoreProvider>(context, listen: true).getInterests(
            Provider.of<MyAuthProvider>(context, listen: true).user!.uid);
    // Get newsletter address
    Future<String> userEmailFuture =
        Provider.of<FirestoreProvider>(context, listen: true)
            .getNewsletterAddress(
                Provider.of<MyAuthProvider>(context, listen: true).user!.uid);
    // Get newsletter period
    Future<int> newsletterPeriodFuture =
        Provider.of<FirestoreProvider>(context, listen: true)
            .getNewsletterPeriod(
                Provider.of<MyAuthProvider>(context, listen: true).user!.uid);
    return FutureBuilder(
        future: Future.wait([
          topicsFuture,
          userEmailFuture,
          newsletterPeriodFuture,
          userTopicsFuture
        ]),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            _topics = snapshot.data![0] as List<String>;
            _period = snapshot.data![2] as int;
            _selected = snapshot.data![3] as List<String>;
            String _email = snapshot.data![1];
            return Scaffold(
              appBar: AppBar(
                title: const Text('Settings'),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Switch(
                              value: _newsletter,
                              onChanged: (value) {
                                setState(() {
                                  _newsletter = value;
                                });
                              }),
                          SizedBox(width: 10),
                          Text('Newsletter',
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SizedBox(
                            width: 30,
                          ),
                          Text('Receive every'),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '3',
                              ),
                              controller: TextEditingController(
                                  text: _period.toString()),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (value) {
                                if (!value.isEmpty) {
                                  // if value is int
                                  if (int.tryParse(value) != null) {
                                    int val = int.parse(value);
                                    if (val > 0) {
                                      Provider.of<FirestoreProvider>(context,
                                              listen: false)
                                          .setNewsletterPeriod(
                                              Provider.of<MyAuthProvider>(
                                                      context,
                                                      listen: false)
                                                  .user!
                                                  .uid,
                                              val);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text('days'),
                        ],
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: TextEditingController(text: _email),
                          textInputAction: TextInputAction.done,
                          onSubmitted: (value) {
                            Provider.of<FirestoreProvider>(context,
                                    listen: false)
                                .setNewsletterAddress(
                                    Provider.of<MyAuthProvider>(context,
                                            listen: false)
                                        .user!
                                        .uid,
                                    value);
                          },
                          decoration: InputDecoration(
                            labelText: 'Send to',
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text('Sources & Interests',
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 10),
                      WideButton(
                          child: Text('Customise Interests'),
                          onPressed: () async {
                            // print('edit interests');
                            await showDialog(
                              context: context,
                              builder: (ctx) {
                                return MultiSelectDialog(
                                  items: _topics
                                      .map((e) => MultiSelectItem(e, e))
                                      .toList(),
                                  // unselectedColor: Colors.grey[400],
                                  initialValue: _selected,
                                  onConfirm: (values) {
                                    _selected = values;
                                    String uid = Provider.of<MyAuthProvider>(
                                            context,
                                            listen: false)
                                        .user!
                                        .uid;
                                    Provider.of<FirestoreProvider>(context,
                                            listen: false)
                                        .setInterests(uid, _selected);
                                  },
                                );
                              },
                            );
                          }),
                      SizedBox(height: 10),
                      WideButton(
                        onPressed: () {
                          // Navigate to the home page by replacing the current route.
                          // Navigator.pop(context);
                        },
                        // color: Colors.blue[800],
                        // textColor: Colors.white,
                        child: const Text('Edit Sources'),
                      ),
                      SizedBox(height: 20),
                      Text('Account',
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 10),
                      WideButton(
                        onPressed: () {
                          // Navigate to the home page by replacing the current route.
                          Provider.of<MyAuthProvider>(context, listen: false)
                              .signOut();
                        },
                        color: Colors.blue[300],
                        textColor: Colors.white,
                        child: const Text('Logout'),
                      ),
                      SizedBox(height: 10),
                      WideButton(
                        onPressed: () {
                          // Navigate to the home page by replacing the current route.
                          // Provider.of<MyAuthProvider>(context, listen: false)
                          // .deleteUser();
                        },
                        color: Colors.red[400],
                        textColor: Colors.white,
                        child: const Text('Delete Account'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
