import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/phoneVerificationScreen.dart';
import 'package:todo_app/textFormField.dart';

class PhoneOtp extends StatefulWidget {
  const PhoneOtp({super.key});

  @override
  State<PhoneOtp> createState() => _PhoneOtpState();
}

class _PhoneOtpState extends State<PhoneOtp> {
  final formKey = GlobalKey<FormState>();
  final otp = TextEditingController();

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
                "Verify your OTP",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent),
              ),
              const SizedBox(
                height: 25,
              ),
              textFormField(
                textFieldName: "Enter your OTP",
                textLableName: "OTP",
                control: otp,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Required OTP";
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  otpVerify();
                  Navigator.pushReplacementNamed(context, '/showdata');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                ),
                child: const Text("Register OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  otpVerify() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: PhoneVerification.verified, smsCode: otp.text);
    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
