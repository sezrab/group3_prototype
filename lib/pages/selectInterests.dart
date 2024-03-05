import 'package:flutter/material.dart';
import 'package:group3_prototype/providers/api.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:group3_prototype/providers/firestore.dart';
import 'package:group3_prototype/reuse.dart/wideButton.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class SelectInterests extends StatefulWidget {
  const SelectInterests({super.key});

  @override
  State<SelectInterests> createState() => _SelectInterestsState();
}

class _SelectInterestsState extends State<SelectInterests> {
  List<String> _selected = [];
  List<String> _topics = [];
  @override
  Widget build(BuildContext context) {
    Future<List<String>> _topicsFuture =
        Provider.of<APIProvider>(context, listen: false).getTopics();
    return FutureBuilder<List<String>>(
      future: _topicsFuture,
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            // show message box
            var t = TextEditingController(
                text: Provider.of<APIProvider>(context, listen: false)
                    .getAPIURL());

            return AlertDialog(
              title: const Text('Server URL'),
              content: TextField(
                controller: t,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    Provider.of<APIProvider>(context, listen: false)
                        .setAPIURL(t.text);
                    setState(() {});
                  },
                ),
              ],
            );
          } else {
            _topics = snapshot.data!;
            return Scaffold(
              appBar: AppBar(
                title: const Text('Select Interests'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MultiSelectDialogField(
                      items: _topics.map((e) => MultiSelectItem(e, e)).toList(),
                      listType: MultiSelectListType.CHIP,
                      onConfirm: (values) {
                        _selected = values;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: WideButton(
                            onPressed: () {
                              String uid = Provider.of<MyAuthProvider>(context,
                                      listen: false)
                                  .user!
                                  .uid;

                              Provider.of<FirestoreProvider>(context,
                                      listen: false)
                                  .setInterests(uid, _selected);
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 150),
                  ],
                ),
              ),
            );
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
