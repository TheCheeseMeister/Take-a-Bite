import 'package:flutter/material.dart';
import 'login_pages.dart';
import 'navbar.dart';

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
      routes: {
        '/': (context) => const CreateAccount(), // App Startup; Enter email to create account
        '/CreateUserPass': (context) => const CreateUserPass(), // Create account with Username and Password
        '/Login': (context) => const LoginPage(), // Log in with existing Username and Password
        '/Nav': (context) => const NavBar(), // Nav Bar, representing main app
      },
      initialRoute: '/',
    );
  }
}