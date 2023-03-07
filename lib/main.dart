import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/loginPage.dart';
import 'package:todo_app/phoneOtpScreen.dart';
import 'package:todo_app/phoneVerificationScreen.dart';
import 'package:todo_app/registerPage.dart';
import 'package:todo_app/show_data.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/login":(context) => LoginPage(),
        "/register":(context) => RegisterPage(),
        "/showdata":(context) => ShowData(),
        "/phonevari":(context) => PhoneVerification(),
        "/otpscreen":(context) => PhoneOtp(),
      },
      debugShowCheckedModeBanner: false,
      locale: Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: PhoneVerification(),
    );
  }
}
