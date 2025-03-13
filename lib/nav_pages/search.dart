import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return const FractionallySizedBox(
      widthFactor: 0.9,
      child: Card(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image(image: AssetImage('lib/imgs/pizza.jpg'))
            ),
            ListTile(
              title: Text("How to make a pizza in 10 minutes"),
              subtitle: Text("15 mins | 4 - 5 people"),
            ),
          ],
        ),
      ),
    );
  }
}
