import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group3_prototype/providers/auth.dart';
import 'package:group3_prototype/providers/firestore.dart';
import 'package:group3_prototype/reuse.dart/wideButton.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
          child: Column(
            children: [
              Text('NLPress',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      )),
              const Text('Register a new account.'),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'What should we call you?',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(height: 20),
              WideButton(
                onPressed: () async {
                  // Navigate to the home page by replacing the current route.
                  try {
                    // make sure passwords match
                    if (passwordController.text !=
                        confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Passwords don't match"),
                        ),
                      );
                    }
                    await Provider.of<MyAuthProvider>(context, listen: false)
                        .registerWithPassword(
                      emailController.text,
                      passwordController.text,
                    )
                        .then((value) {
                      var cu = FirebaseAuth.instance.currentUser!;
                      var uid = cu.uid;
                      var email = cu.email!;
                      Provider.of<FirestoreProvider>(context, listen: false)
                          .setName(uid, nameController.text, update: false);
                      Provider.of<FirestoreProvider>(context, listen: false)
                          .setNewsletterAddress(uid, email);
                      Navigator.pop(context);
                    });
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
        ),
      ),
    );
  }
}
