import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
              child: Text("Search/Home Page (this would be search bar)"),
            ),
            RecipeCard(),
          ],
        ),
      ),
    );
  }
}

// Recipe displayed on Search Page
class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key});

  // Both normally not hard-coded, but for sake of placeholder
  final String title = "How to make a pizza in 10 minutes";
  final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: InkWell(
        onTap: () => PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(),
          screen: RecipePage(image: image, title: title),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        ),
        child: const Card(
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Hero(
                      tag: 'recipe-image',
                      child: Image(image: AssetImage('lib/imgs/pizza.jpg')))),
              ListTile(
                title: Hero(
                  tag: 'recipe-title',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Text("How to make a pizza in 10 minutes")
                  ),
                ),
                subtitle: Text("15 mins | 4 - 5 people"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.image, required this.title});

  final Image image;
  final String title;

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return Scaffold(
      body: Column(
        children: [
          Hero(
            tag: 'recipe-image',
            child: image,
          ),
          Text(title),
        ],
      ),
    );
  }
}
