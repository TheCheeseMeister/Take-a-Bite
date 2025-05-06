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
                          // Open a menu with buttons labeled 'Change Username' and 'Change Password'
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Change Username or Password"),
                                content: const Text("Choose an option:"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the current dialog
                                      // Open a dialog to change the username
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Change Username"),
                                            content: TextField(
                                              decoration: const InputDecoration(
                                                labelText: "Enter new username",
                                              ),
                                              onSubmitted: (value) {
                                                // Handle username change logic here
                                                print("New Username: $value");
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("Change Username"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the current dialog
                                      // Open a dialog to change the password
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Change Password"),
                                            content: TextField(
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                labelText: "Enter new password",
                                              ),
                                              onSubmitted: (value) {
                                                // Handle password change logic here
                                                print("New Password: $value");
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(); // Close the dialog
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text("Change Password"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("Change Username or Password"),
                      ),
                    ),
                    const SizedBox(height: 16), // Add space between buttons
                    SizedBox(
                      width: 250, // Set a fixed width for the button
                      child: OutlinedButton(
                        onPressed: () {
                          // Open a 'select theme' menu
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Select Theme"),
                                content: const Text("Choose a theme for the app."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text("App Theme"),
                      ),
                    ),
                    const SizedBox(height: 16), // Add space between buttons
                    SizedBox(
                      width: 250, // Set a fixed width for the button
                      child: OutlinedButton(
                        onPressed: () {
                          // Log out the user and navigate to the login page
                          Navigator.of(context).pushReplacementNamed('/login_pages.dart');
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