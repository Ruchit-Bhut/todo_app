import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/phoneOtpScreen.dart';
import 'package:todo_app/textFormField.dart';

class PhoneVerification extends StatefulWidget {
  static String verified = "";

  const PhoneVerification({super.key});

  @override
  State<PhoneVerification> createState() => _PhoneVerificationState();
}

class _PhoneVerificationState extends State<PhoneVerification> {
  final formKey = GlobalKey<FormState>();
  final phoneNumber = TextEditingController();
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
                "Verify your phonenumber",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              const SizedBox(
                height: 25,
              ),
              textFormField(
                textFieldName: "Enter your Phone Number",
                textLableName: "Phone Number",
                control: phoneNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required Phone Number";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  phoneVerify();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("Generate OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }

   phoneVerify() async {
    final auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
          phoneNumber: phoneNumber.text,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(e.code)));
          },
          codeSent: (String verificationId, int? resendToken) {
            PhoneVerification.verified = verificationId;
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PhoneOtp(),));
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    } on FirebaseAuthException {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("error")));
    }
  }
}
