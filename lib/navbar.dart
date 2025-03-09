import 'package:flutter/material.dart';
import 'package:take_a_bite/nav_pages/search.dart';
import 'package:take_a_bite/nav_pages/meal_plan.dart';
import 'package:take_a_bite/nav_pages/profile.dart';
import 'package:take_a_bite/nav_pages/settings.dart';

// Nav Bar for main app, controller of different pages
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0; // Current page index for bottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: const Color.fromARGB(255, 109, 205, 243),
        selectedIndex: currentIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_note),
            label: 'Meal Plan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        const Search(),
        const MealPlan(),
        const Profile(),
        const Settings(),
      ][currentIndex],
    );
  }
}