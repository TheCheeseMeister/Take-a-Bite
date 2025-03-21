import 'package:flutter/material.dart';
import 'package:take_a_bite/nav_pages/search.dart';
import 'package:take_a_bite/nav_pages/meal_plan.dart';
import 'package:take_a_bite/nav_pages/profile.dart';
import 'package:take_a_bite/nav_pages/settings.dart';

import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

// Nav Bar for main app, controller of different pages
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: const [
        Search(),
        MealPlan(),
        Profile(),
        Settings(),
      ],
      items: [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.search),
          title: "Search",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: "/",
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.event_note),
          title: "Meal Plan",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: "/",
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Profile",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: "/",
          ),
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.settings),
          title: "Settings",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
            initialRoute: "/",
          ),
        ),
      ],
      hideNavigationBarWhenKeyboardAppears: true,
      backgroundColor: const Color.fromARGB(255, 238, 238, 238),
      isVisible: true,
      confineToSafeArea: true,
      navBarHeight: 66,
      navBarStyle: NavBarStyle.style3,
    );
  }
}