import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          const Text('NLPress'),
          const Text('Register a new account.'),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Navigate to the home page by replacing the current route.
              try {
                await Provider.of<MyAuthProvider>(context, listen: false)
                    .registerWithPassword(
                      emailController.text,
                      passwordController.text,
                    )
                    .then((value) => Navigator.pop(context));
              }
              // catch firebase errors and display appropriate text
              on FirebaseAuthException catch (e) {
                String message = "There was an error";
                if (e.code == 'weak-password') {
                  message = "The password provided is too weak.";
                } else if (e.code == 'email-already-in-use') {
                  message = "The account already exists for that email.";
                } else if (e.code == 'invalid-email') {
                  message = "The email address is invalid.";
                } else if (e.code == 'operation-not-allowed') {
                  message = "Email & Password accounts are not enabled.";
                } else if (e.code == 'user-disabled') {
                  message =
                      "The user corresponding to the given email has been disabled.";
                } else if (e.code == 'user-not-found') {
                  message =
                      "There is no user corresponding to the given email.";
                } else if (e.code == 'wrong-password') {
                  message = "The password is invalid for the given email.";
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
