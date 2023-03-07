import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/textFormField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose(){
    email.dispose();
    password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to TODO App",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              const SizedBox(
                height: 25,
              ),
              textFormField(
                textFieldName: "Enter your Email",
                textLableName: "User Name",
                control: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required Email";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              textFormField(
                textFieldName: "Enter your Password",
                textLableName: "Password",
                control: password,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required Password";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  signIn();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("Login"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.deepPurpleAccent),
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

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text,
          password: password.text
      );
      Navigator.pushReplacementNamed(context, '/showdata');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No User Found"),),);
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong password"),),);
      }
    }
  }
}
