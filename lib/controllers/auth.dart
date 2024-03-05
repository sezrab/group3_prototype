import 'package:flutter/material.dart';
import 'package:group3_prototype/home.dart';
import 'package:group3_prototype/pages/selectInterests.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:group3_prototype/providers/firestore.dart';
import 'package:provider/provider.dart';

import '../pages/login.dart';

class LoginRegisterHome extends StatelessWidget {
  const LoginRegisterHome({super.key});

  @override
  Widget build(BuildContext context) {
    // get provider of auth
    // if user is authenticated, show home page
    if (Provider.of<MyAuthProvider>(context, listen: true).isAuthenticated) {
      String uid =
          Provider.of<MyAuthProvider>(context, listen: false).user!.uid;
      Future<List<String>> interests =
          Provider.of<FirestoreProvider>(context, listen: true)
              .getInterests(uid);
      return FutureBuilder<List<String>>(
        future: interests,
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              if (snapshot.data!.isEmpty) {
                return const SelectInterests();
              } else {
                return const Home();
              }
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    } else {
      // if user is not authenticated, show login page
      return const Login();
    }
  }
}
