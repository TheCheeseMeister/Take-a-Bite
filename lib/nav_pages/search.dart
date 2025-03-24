import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import './recipe.dart';

// TODO: make StatefulWidget to allow setting of values
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
              // Would-be search bar
              child: Text("Search/Home Page (this would be search bar)"),
            ),
            RecipeCard(), // Should be list of RecipeCards that match result (0 or more)
          ],
        ),
      ),
    );
  }
}

// Recipe displayed on Search Page
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  // Normally loaded from database, but for sake of placeholder
  final String title = "How to make a pizza in 10 minutes";
  final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));
  final int prepTime = 10;
  final int cookTime = 10;
  final String servingSize = "4 - 5 people";
  final int index = 0; // Eventually will be put in a list, this will be its position

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: InkWell(
        onTap: () => PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(),
          screen: RecipePage(
              image: image,
              title: title,
              prepTime: prepTime,
              cookTime: cookTime,
              servingSize: servingSize,
              index: index),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        ),
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Hero(tag: 'recipe-$index', child: image)),
              ListTile(
                  title: const Hero(
                    tag: 'recipe-title',
                    child: Material(
                        type: MaterialType.transparency,
                        child: Text("How to make a pizza in 10 minutes",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ))),
                  ),
                  subtitle: Text(
                      "$cookTime mins | $servingSize") //Text("15 mins | 4 - 5 people"),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
