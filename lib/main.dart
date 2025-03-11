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
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromRGBO(
              255, 255, 255, 1)), // Background color of Main App
      routes: {
        '/': (context) =>
            const CreateAccount(), // App Startup; Enter email to create account
        '/CreateUserPass': (context) =>
            const CreateUserPass(), // Create account with Username and Password
        '/Login': (context) =>
            const LoginPage(), // Log in with existing Username and Password
        '/Nav': (context) => const NavBar(), // Nav Bar, representing main app
      },
      initialRoute: '/',
      // For transitions maybe eventually
      /*onGenerateRoute: (route) {
        switch(route.name) {
          case '/':
            // Slide transition
            return PageRouteBuilder(
              settings: route,
              pageBuilder: (context, animation, secondaryAnimation) => CreateAccount(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const startPos = Offset(-1.0, 0.0);
                const endPos = Offset.zero;
                const slideCurve = Curves.easeInOut;

                var tween = Tween(begin: startPos, end: endPos).chain(CurveTween(curve: slideCurve));
                var offsetAnim = animation.drive(tween);
                return SlideTransition(position: offsetAnim, child: child);
              }
            );
          case '/Login':
            // TODO: Edit transition for page (or remove)
            return PageRouteBuilder(
              settings: route,
              pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
              //transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
            );
          case '/CreateUserPass':
            // Slide transition
            return PageRouteBuilder(
              settings: route,
              pageBuilder: (context, animation, secondaryAnimation) => CreateUserPass(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const startPos = Offset(1.0, 0.0);
                const endPos = Offset.zero;
                const slideCurve = Curves.easeInOut;

                var tween = Tween(begin: startPos, end: endPos).chain(CurveTween(curve: slideCurve));
                var offsetAnim = animation.drive(tween);
                return SlideTransition(position: offsetAnim, child: child);
              }
            );
          default:
            return null;
        }
      }*/
    );
  }
}
