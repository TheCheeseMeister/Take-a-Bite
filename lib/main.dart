import 'package:flutter/material.dart';
import './login page/create_account.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Take-a-Bite",
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1)), // Background color of Main App
      home: const CreateAccount(),
    );
  }
}