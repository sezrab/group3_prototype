import 'package:flutter/material.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              // Navigate to the home page by replacing the current route.
              Provider.of<MyAuthProvider>(context, listen: false).signOut();
              // Navigator.pushNamed(context, '/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
