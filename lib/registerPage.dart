import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/textFormField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Register",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              const SizedBox(
                height: 25,
              ),
              textFormField(
                textFieldName: "Enter your Email ID",
                textLableName: "Email ID",
                control: _email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required Email ID";
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              textFormField(
                textFieldName: "Enter your Password",
                textLableName: "Password",
                control: _password,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required Password";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  register();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("Register"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.grey),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text(
                      "Login",
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

  Future register() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password is weak"),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Account Already Exists"),
          ),
        );
      }
    }
  }
}
