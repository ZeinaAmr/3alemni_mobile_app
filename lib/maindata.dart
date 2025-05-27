import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '3allemni',
      theme: ThemeData(
        primaryColor: const Color(0xFF13A7B1),
      ),
      home: LoginPage(),
    );
  }
}
