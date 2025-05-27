import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'SignUpPage.dart';
import 'package:allemni/ForgotPasswordPage.dart';
import 'package:allemni/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding before async calls

  await Firebase.initializeApp(); // Initialize Firebase

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: {
        '/home': (context) => HomePage(),
        '/signup': (context) => SignUpPage(),
        '/forgot_password': (context) => ForgotPasswordPage(),
      },
    );
  }
}
