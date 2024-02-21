import 'package:flutter/material.dart';
import 'package:group3_prototype/home.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:provider/provider.dart';

import '../pages/login.dart';

class LoginRegisterHome extends StatelessWidget {
  const LoginRegisterHome({super.key});

  @override
  Widget build(BuildContext context) {
    // get provider of auth
    // if user is authenticated, show home page
    if (Provider.of<MyAuthProvider>(context, listen: true).isAuthenticated) {
      return const Home();
    } else {
      // if user is not authenticated, show login page
      return const Login();
    }
  }
}
