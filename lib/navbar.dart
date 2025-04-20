import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:take_a_bite/globals.dart' as globals;
import 'package:take_a_bite/nav_pages/create_recipe.dart';
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

  // Your profile info - passes your parameters to Profile
  final String profileImage = "lib/imgs/cheeseprofile.PNG";
  final String displayName = "CheeseLover";
  final String username = "@CheeseBros";
  final int followers = 0;
  final int recipes = 0;
  final String bio = "Cooking Legend.\nSeeking cheese recipes night and day.\n#CheeseLovers25";

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getCreatedRecipes(int user_id) async {
      var url = Uri.http('3.93.61.3', '/api/feed/userRecipes/$user_id');
      var response = await http.get(url,
          headers: {
            "Authorization": 'Bearer ${globals.token}',
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
      );
      final data = jsonDecode(response.body)['user_recipes'];
      return data;
    }
    
    return PersistentTabView(
      context,
      controller: _controller,
      screens: [
        const Search(),
        const MealPlan(),
        const CreateRecipe(),
        Profile(
          profileImage: profileImage,
          displayName: displayName,
          username: username,
          followers: followers,
          recipes: recipes,
          bio: bio,
        ),
        const Settings(),
      ],
      onItemSelected: (index) async {
        if (index == 3) {
          int user_id = globals.user['user_id'];
          List<dynamic> tempCreated = await getCreatedRecipes(user_id);
          setState(() {globals.createdRecipes = tempCreated;});
        }
      },
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
          icon: const Icon(Icons.add),
          title: "Create Recipe",
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