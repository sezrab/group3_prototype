import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Text('NLPress',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const Text('Please login to continue.'),
            // username and password fields
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text,
                )
                    .onError((error, stackTrace) {
                  String message = "Login failed. Please try again.";
                  if (error is FirebaseAuthException) {
                    if (error.code == 'user-not-found') {
                      message = 'No user found for that email.';
                    } else if (error.code == 'wrong-password') {
                      message = 'Wrong password provided for that user.';
                    }
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                  throw error as Object;
                });
              },
              child: Text('Login',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white)),
            ),
            // or register
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register',
                  style: Theme.of(context).textTheme.labelLarge),
            ),
          ],
        ),
      ),
    );
  }
}
