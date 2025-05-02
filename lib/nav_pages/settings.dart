import 'package:flutter/material.dart';

//build three buttons labeled "change username or password", "app theme", and "log out"
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute content vertically
          crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
          children: [
            const SizedBox(height: 32), // Add space at the top
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center buttons vertically
                  children: [
                    SizedBox(
                      width: 250, // Set a fixed width for the button
                      child: OutlinedButton(
                        onPressed: () {
                          // Add functionality for "Change Username or Password"
                        },
                        child: const Text("Change Username or Password"),
                      ),
                    ),
                    const SizedBox(height: 16), // Add space between buttons
                    SizedBox(
                      width: 250, // Set a fixed width for the button
                      child: OutlinedButton(
                        onPressed: () {
                          // Add functionality for "App Theme"
                        },
                        child: const Text("App Theme"),
                      ),
                    ),
                    const SizedBox(height: 16), // Add space between buttons
                    SizedBox(
                      width: 250, // Set a fixed width for the button
                      child: OutlinedButton(
                        onPressed: () {
                          // Add functionality for "Log Out"
                        },
                        child: const Text("Log Out"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32), // Add space at the bottom
          ],
        ),
      ),
    );
  }
}