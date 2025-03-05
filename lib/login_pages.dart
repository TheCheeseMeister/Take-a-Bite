import 'package:flutter/material.dart';

// First page/Create Account
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email Address",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    validator: (value) {
                      // TODO: Email validator
                      return (value == null || value.isEmpty)
                          ? "Field can't be empty"
                          : null;
                    },
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
                      foregroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255)),
                      backgroundColor:
                          WidgetStatePropertyAll(Color.fromARGB(255, 0, 0, 0)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                    ),
                    onPressed: () => {
                      if (formKey.currentState!.validate())
                        {Navigator.pushNamed(context, '/CreateUserPass')}
                    },
                    child: const Text("Continue"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 225, 0),
                child: TextButton(
                  onPressed: () => {Navigator.pushNamed(context, '/Login')},
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

// Page for Creating Username and Password
class CreateUserPass extends StatefulWidget {
  const CreateUserPass({super.key});

  @override
  State<CreateUserPass> createState() => _CreateUserPassState();
}

class _CreateUserPassState extends State<CreateUserPass> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation
  final usernameController = TextEditingController(); // Track username value
  final passwordController = TextEditingController(); // Track password value

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Positioned(
                top: 36,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 42,
                  onPressed: () => {
                    Navigator.pushNamed(context, '/')
                  },
                ),
              ),
              Column(
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
                      "Create a Username and Password",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      "Enter a Username and Password for this account",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        validator: (value) {
                          // TODO: Username conditions for validating
                          return (value == null || value.isEmpty)
                              ? "Field can't be empty"
                              : null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          labelStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        validator: (value) {
                          // TODO: Password conditions for validating
                          return (value == null || value.isEmpty)
                              ? "Field can't be empty"
                              : null;
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        validator: (value) {
                          // TODO: Confirm Password conditions for validating
                          return (value != passwordController.text)
                              ? "Passwords must match"
                              : null;
                        },
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
                          foregroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 255, 255, 255)),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 0, 0, 0)),
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                        ),
                        onPressed: () => {
                          if (formKey.currentState!.validate()) {
                            // TODO: Traverse to main app if account creation is successful
                            // Navigator.pushNamed(context, '/CreateUserPass')
                          }
                        },
                        child: const Text("Sign up"),
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
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
                  "Sign in",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                child: Text(
                  "Enter a Username and Password to login",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    validator:(value) {
                      // TODO: Username conditions for validating
                      return (value == null || value.isEmpty)
                        ? "Passwords must match"
                        : null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
                child: SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      labelStyle: TextStyle(fontSize: 14),
                      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    ),
                    validator:(value) {
                      // TODO: Password conditions for validating
                      return (value == null || value.isEmpty)
                        ? "Passwords must match"
                        : null;
                    },
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
                      foregroundColor: WidgetStatePropertyAll(
                          Color.fromARGB(255, 255, 255, 255)),
                      backgroundColor:
                          WidgetStatePropertyAll(Color.fromARGB(255, 0, 0, 0)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                    ),
                    onPressed: () => {
                      if (formKey.currentState!.validate()) {
                        // TODO: Traverse to main app if account login is successful
                        // Navigator.pushNamed(context, '/CreateUserPass')
                      }
                    },
                    child: const Text("Sign in"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                child: TextButton(
                  onPressed: () => {Navigator.pushNamed(context, '/')},
                  child: const Text(
                    "Don't have an account?",
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
