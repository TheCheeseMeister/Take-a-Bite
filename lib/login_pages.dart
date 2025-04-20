import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globals.dart' as globals;

// First page/Create Account
class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  final createEmailController = TextEditingController();

  // Add http request for validation of email (already registered)

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Center(
          child: ListView(children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                  child: Text(
                    "Take-a-Bite",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                  ),
                ),
                /*ingredientsStatus == -1000
                  ? Text("Status Code: Pinging Route...")
                  : Text("Status Code: $ingredientsStatus"),*/
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
                      controller: createEmailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email Address",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      validator: (value) {
                        // TODO: Email validator
                        // Should add validator to check if email has been used or not
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
                        backgroundColor: WidgetStatePropertyAll(
                            Color.fromARGB(255, 0, 0, 0)),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8)))),
                      ),
                      onPressed: () async {
                        // Need extra email validation, but for now
                        /*if (userToken == "") {
                          http.Response response = await setToken();
                          final data = jsonDecode(response.body);
                          final token = data['token'];
                          // globals.token (global token saved for future use)
                          setState(() {userToken = token;});
                          setState(() {ingredientsStatus = response.statusCode;});
                          print(userToken);
                        } else {
                          http.Response response = await checkIngredients();
                          setState(() {ingredientsStatus = response.statusCode;});
                          final data = jsonDecode(response.body);
                          final ingredient = data['ingredients'][1157];
                          print(ingredient);
                        }*/
                        //http.Response response = await checkIngredients();
                        //final data = jsonDecode(response.body);
                        //final token = data['token'];
                        //setState(() {userToken = token;});
                        //setState(() {ingredientsStatus = response.statusCode;});
                        //print(userToken);
                        if (formKey.currentState!.validate())
                          {Navigator.pushNamed(context, '/CreateUserPass', arguments: {'email': createEmailController.text});}
                        /*http.Response response = await testConnection();
                        setState(() {responseStatus = response.statusCode;});*/
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
          ]),
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
    Future<http.Response> checkLogin(String username, String password) async {
      var url = Uri.http('3.93.61.3', '/api/login');
      var response = await http.post(url, headers: {"Accept": "application/json"}, body: {'username': username, 'password': password});
      return response;
    }

    Future<http.Response> checkIngredients() async {
      var url = Uri.http('3.93.61.3', '/api/feed/ingredients');
      var response = await http.get(url, headers: {"Authorization": 'Bearer ${globals.token}', "Accept": "application/json"});
      return response;
    }

    Future<http.Response> checkTags() async {
      var url = Uri.http('3.93.61.3', '/api/feed/tag');
      var response = await http.get(url, headers: {"Authorization": 'Bearer ${globals.token}', "Accept": "application/json"});
      return response;
    }

    final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final email = arguments['email'];

    int registerStatus = -1000;

    Future<http.Response> checkRegister(String username, String password) async {
      // Register
      var url = Uri.http('3.93.61.3', '/api/register');
      var response = await http.post(url, headers: {"Accept": "application/json"}, body: {'username': username, 'email': email, 'password': password});
      return response;
    }

    return Form(
      key: formKey,
      child: Scaffold(
        body: ListView(children: [
          Center(
            child: Stack(children: [
              Positioned(
                top: 36,
                left: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 42,
                  onPressed: () => {Navigator.pushNamed(context, '/')},
                ),
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                    child: Text(
                      "Take-a-Bite",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Text(
                      "Create a Username and Password",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
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
                              : value.length < 4
                              ? "Username must be minimum 4 characters long"
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
                              : value.length < 6
                              ? "Password must be minimum 6 characters long"
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
                        onPressed: () async {
                          http.Response registerResponse = await checkRegister(usernameController.text, passwordController.text);
                          setState(() {registerStatus = registerResponse.statusCode;});
                          // TODO: Add token and ingredients
                          if (formKey.currentState!.validate() && registerStatus == 201)
                            {
                              // TODO: Traverse to main app if account creation is successful
                              final loginData = jsonDecode(registerResponse.body);
                              setState(() {globals.token = loginData['token'];});
                              setState(() {globals.user = loginData['user'];});

                              http.Response ingredientsResponse = await checkIngredients();
                              final ingredientsData = jsonDecode(ingredientsResponse.body);
                              globals.ingredientsList = ingredientsData['ingredients'];

                              http.Response tagResponse = await checkTags();
                              final tagsData = jsonDecode(tagResponse.body);
                              globals.tagsList = tagsData['tag_name'];

                              if (globals.user['user_bio'] != null) {
                                globals.userBio = ValueNotifier<String>(globals.user['user_bio']);
                              }

                              Navigator.pushNamed(context, '/Nav');
                            }
                        },
                        child: const Text("Sign up"),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}

// Page for logging into existing account
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  int loginStatus = -1000;
  int ingredientsStatus = -1000;

  Future<http.Response> checkLogin(String username, String password) async {
    var url = Uri.http('3.93.61.3', '/api/login');
    var response = await http.post(url, headers: {"Accept": "application/json"}, body: {'username': username, 'password': password});
    return response;
  }

  Future<http.Response> checkIngredients() async {
    var url = Uri.http('3.93.61.3', '/api/feed/ingredients');
    var response = await http.get(url, headers: {"Authorization": 'Bearer ${globals.token}', "Accept": "application/json"});
    return response;
  }

  Future<http.Response> checkTags() async {
    var url = Uri.http('3.93.61.3', '/api/feed/tag');
    var response = await http.get(url, headers: {"Authorization": 'Bearer ${globals.token}', "Accept": "application/json"});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Center(
          child: ListView(children: [
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
                      controller: loginUsernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Username",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      validator: (value) {
                        // TODO: Username conditions for validating
                        return (value == null || value.isEmpty)
                            ? "Username field can't be empty."
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
                      controller: loginPasswordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        labelStyle: TextStyle(fontSize: 14),
                        contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      ),
                      validator: (value) {
                        // TODO: Password conditions for validating
                        return (value == null || value.isEmpty)
                            ? "Password field can't be empty"
                            : loginStatus != 200
                            ? "Username or Password is incorrect"
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
                      onPressed: () async {
                        http.Response loginResponse = await checkLogin(loginUsernameController.text, loginPasswordController.text);
                        setState(() {loginStatus = loginResponse.statusCode;});

                        if (formKey.currentState!.validate() && loginStatus == 200)
                          {
                            final loginData = jsonDecode(loginResponse.body);
                            setState(() {globals.token = loginData['token'];});
                            setState(() {globals.user = loginData['user'];});

                            http.Response ingredientsResponse = await checkIngredients();
                            setState(() {ingredientsStatus = ingredientsResponse.statusCode;});
                            final ingredientsData = jsonDecode(ingredientsResponse.body);
                            globals.ingredientsList = ingredientsData['ingredients'];

                            http.Response tagResponse = await checkTags();
                            final tagsData = jsonDecode(tagResponse.body);
                            globals.tagsList = tagsData['tag_name'];

                            print('Tags Status: ${tagResponse.statusCode}');
                            print('Tag test: ${globals.tagsList}');

                            print('Login Status: $loginStatus');
                            print('Ingredients Status: $ingredientsStatus');
                            print('Ingredient test: ${globals.ingredientsList}');
                            print('User info: ${globals.user}');

                            if (globals.user['user_bio'] != null) {
                              globals.userBio = ValueNotifier<String>(globals.user['user_bio']);
                            }

                            Navigator.pushNamed(context, '/Nav');
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
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 150, 0),
                  child: TextButton(
                    onPressed: () =>
                        {Navigator.pushNamed(context, '/ResetEmail')},
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      "Forgot your password?",
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
          ]),
        ),
      ),
    );
  }
}

class ResetEmail extends StatefulWidget {
  const ResetEmail({super.key});

  @override
  State<ResetEmail> createState() => _ResetEmailState();
}

class _ResetEmailState extends State<ResetEmail> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  final resetEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
        body: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                    child: Text(
                      "Password Reset",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Text(
                      "Enter Email of an Existing Account",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      "We will email a validation code to authenticate",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: resetEmailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email",
                          labelStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        validator: (value) {
                          // TODO: Username conditions for validating
                          return (value == null || value.isEmpty)
                              ? "Email field can't be empty"
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
                          if (formKey.currentState!.validate())
                            {
                              // TODO: Traverse to main app if account login is successful
                              Navigator.pushNamed(context, '/ResetValidate',
                                  arguments: {
                                    'email': resetEmailController.text
                                  })
                            }
                        },
                        child: const Text("Send Validation Code"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetValidate extends StatefulWidget {
  const ResetValidate({super.key});

  @override
  State<ResetValidate> createState() => _ResetValidateState();
}

class _ResetValidateState extends State<ResetValidate> {
  final formKey =
      GlobalKey<FormState>(); // Keeps track of form state for validation

  final code = "103476"; // Would be generated, but for now.

  void sendEmail() async {
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final email = arguments["email"];

    return Form(
      key: formKey,
      child: Scaffold(
        body: Center(
          child: ListView(
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 160, 0, 0),
                    child: Text(
                      "Authentication",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 42),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                    child: Text(
                      "Enter Validation Code",
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    child: Text(
                      "The validation code will be found in your email",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Text("Also email: $email"),
                  Text("Validation code?: $code"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
                    child: SizedBox(
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Validation Code",
                          labelStyle: TextStyle(fontSize: 14),
                          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        ),
                        validator: (value) {
                          // TODO: Username conditions for validating
                          return (value == null || value.isEmpty)
                              ? "Validation Code field can't be empty"
                              : null;
                        },
                      ),
                    ),
                  ),
                  /*Padding(
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
                          if (formKey.currentState!.validate())
                            {
                              // TODO: Traverse to main app if account login is successful
                              Navigator.pushNamed(context, '/ResetValidate', arguments: {'email': resetEmailController})
                            }
                        },
                        child: const Text("Send Validation Code"),
                      ),
                    ),
                  ),*/
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
