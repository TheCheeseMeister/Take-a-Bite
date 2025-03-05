import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Take-a-Bite",
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromRGBO(255, 255, 255, 1)), // Background color of Main App
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                child: Text(
                  "Take-a-Bite",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child: Text(
                  "Create an Account", 
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  "Enter your email to sign up for this app", 
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: 
                      InputDecoration(border: OutlineInputBorder(),
                      labelText: "Email Address",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: TextButton(
                    style: const ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 255, 255, 255)),
                      backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 0, 0, 0)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                    ),
                    onPressed: () => {},
                    child: const Text("Continue"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 225, 0),
                child: TextButton(
                  onPressed: () => {},
                  child: const Text(
                    "Signing in?", 
                    style: TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Color.fromRGBO(33, 148, 255, 1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}