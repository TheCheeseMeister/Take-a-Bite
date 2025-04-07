import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/fake_instruct.dart';
import './recipe.dart';

import 'package:dropdown_search/dropdown_search.dart';

// TODO: make StatefulWidget to allow setting of values
class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
              // Would-be search bar
              //child: Text("Search bar not finished"),
              child: SearchBar(),
            ),
            RecipeCard(), // Should be list of RecipeCards that match result (0 or more)
          ],
        ),
      ),
    );
  }
}

// Search Bar (uses Dropdown_Search package)
class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      child: DropdownSearch<String>.multiSelection(
        items: (filter, s) => ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
        compareFn: (i, s) => i == s,
        onChanged: (List<String> selectedItems) {
          // TODO: add httprequest to search for recipes with selected items
        },
        popupProps: PopupPropsMultiSelection.menu(
          menuProps: const MenuProps(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
          showSearchBox: true,
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
              child: Text(item.toString()),
            );
          },
        ),
      ),
    );
  }
}

// Recipe displayed on Search Page
class RecipeCard extends StatelessWidget {
  RecipeCard({super.key});

  // Normally loaded from database, but for sake of placeholder
  final String title = "How to make a pizza in 10 minutes";
  final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));
  final List<String> ingredients = fakeIngredients();
  final int prepTime = 10;
  final int cookTime = 10;
  final String servingSize = "4 - 5 people";
  final int index = 0; // Eventually will be put in a list, this will be its position
  String description = fakeInstructions();

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
              ingredients: ingredients,
              prepTime: prepTime,
              cookTime: cookTime,
              servingSize: servingSize,
              instructions: description,
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
