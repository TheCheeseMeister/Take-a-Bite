import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/fake_instruct.dart';
import './recipe.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:take_a_bite/globals.dart' as globals;

List<Map<String, dynamic>> recipes = [];
List<List<dynamic>> ingredients = [];

List<Map<String, dynamic>> recipeIngredients = [];

bool searching = false;

// TODO: make StatefulWidget to allow setting of values
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<void> getRecipes() async {
    setState(() {recipes.clear();});

    var url = Uri.http('3.93.61.3', '/api/feed/recipe');
    var response = await http.get(url,
        headers: {
          "Authorization": 'Bearer ${globals.token}',
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
    );

    var data = jsonDecode(response.body)['recipe_name'];
    //data.shuffle(); Use this for randomizing order
    data = data.reversed.toList();
    
    for (var i = 0; i < 10; i++) {
      setState(() {recipes.add(data[i]);});
    }
  }

  Future<void> getRecipeIngredients(int recipe_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/recipeIngredient/$recipe_id');
    var response = await http.get(url,
        headers: {
          "Authorization": 'Bearer ${globals.token}',
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
    );
    final data = jsonDecode(response.body)['ingredients'];
    setState(() {ingredients.add(data);});
    print(recipe_id);
  }

  void buildRecipeIngredients() {
    for (var r_ingredients in ingredients) {
      if (r_ingredients.isNotEmpty) {
        var ri_recipe_id = r_ingredients[0]['ri_recipe_id'];

        Map<String, dynamic> recipe = {};
        recipe['recipe_id'] = ri_recipe_id;

        Map<String, dynamic> recipe_ingredients = {};
        for (var i = 0; i < r_ingredients.length; i++) {
          Map<String, dynamic> ingredient_info = {};
          var ingredient_id = r_ingredients[i]['ri_ingredient_id']-1;
          var ingredient_name = globals.ingredientsList[ingredient_id]['ingredient_name'];
          var portion = r_ingredients[i]['ri_ingredient_measurement'];

          ingredient_info['ingredient_name'] = ingredient_name;
          ingredient_info['portion'] = portion;
          recipe_ingredients['$ingredient_id'] = ingredient_info;
        }

        recipe['ingredients'] = recipe_ingredients;
        
        recipeIngredients.add(recipe);
        print(recipe);
      }
    }
  }

  Future<void> handleSearch() async {
    setState(() {searching = true;});

    await getRecipes();
            
    setState(() {ingredients = [];});
    for (var recipe in recipes) {
      await getRecipeIngredients(recipe['recipe_id']);
    }
            
    print(ingredients.length);
    print(globals.ingredientsList);
    buildRecipeIngredients();

    setState(() {searching = false;});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
                child: SearchBar(searchMethod: handleSearch),
              ),
              searching
              ? const Padding(
                padding: EdgeInsets.fromLTRB(0,48,0,0),
                child: CircularProgressIndicator(),
              )
              : recipes.isEmpty
              ? const Text("No Results.")
              : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(recipes.length, (index) {
                  return RecipeCard(recipeInfo: recipes[index], index: index+1000);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Search Bar (uses Dropdown_Search package)
class SearchBar extends StatefulWidget {
  final Future<void> Function() searchMethod;
  const SearchBar({
    super.key,
    required this.searchMethod,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: SizedBox(
            width: 275,
            child: DropdownSearch<String>.multiSelection(
              //items: (filter, s) => ["a", "b", "c", "d", "e", "f", "g", "h", "i"],
              items: (filter, s) => globals.ingredientsList
                  .map<String>((ingredient) => ingredient['ingredient_name'])
                  .toList(),
              compareFn: (i, s) => i == s,
              onChanged: (List<String> selectedItems) {
                // TODO: add httprequest to search for recipes with selected items
              },
              popupProps: PopupPropsMultiSelection.menu(
                menuProps: const MenuProps(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                showSearchBox: true,
                constraints:
                    const BoxConstraints(maxWidth: 500, maxHeight: 400),
                itemBuilder: (context, item, isDisabled, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                    child: Text(item.toString()),
                  );
                },
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () async {
            await widget.searchMethod();
          },
        ),
      ],
    );
  }
}

// Recipe displayed on Search Page
class RecipeCard extends StatelessWidget {
  final Map<String, dynamic> recipeInfo;
  final int index;

  RecipeCard({
    super.key,
    required this.recipeInfo,
    required this.index,
  });

  // Normally loaded from database, but for sake of placeholder
  //final String title = "How to make a pizza in 10 minutes";
  //final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));
  //final List<String> ingredients = fakeIngredients();
  //final int prepTime = 10;
  //final int cookTime = 10;
  //final String servingSize = "4 - 5 people";
  //final int index = 0; // Eventually will be put in a list, this will be its position
  //String description = fakeInstructions();

  @override
  Widget build(BuildContext context) {
    String title = recipeInfo['recipe_name'];
    String image = recipeInfo['recipe_image'] ?? "";
    String prepTime = recipeInfo['prep_time'];
    String cookTime = recipeInfo['cook_time'];
    String servingSize = recipeInfo['recipe_servings'];
    String description = recipeInfo['recipe_directions'];

    Map<String, dynamic> ingredients = recipeIngredients.firstWhere((element) => element['recipe_id'] == recipeInfo['recipe_id'], orElse: () => {});

    //recipeInfo['recipe_id']

    Image? img = null;

    if (image != "") {
      img = Image.network(image,width: double.infinity,height: 300,fit: BoxFit.cover);
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: InkWell(
        onTap: () => PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
          context,
          settings: const RouteSettings(),
          screen: RecipePage(
              recipeInfo: recipeInfo,
              ingredients: ingredients,
              image: image == "" ? null : img!,
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
                  child: Hero(
                    tag: 'recipe-$index',
                    child: image != ""
                      ? img!
                      : const Icon(
                        Icons.image_not_supported,
                        size: 300,
                        color: Colors.grey,
                      ),
                  )
              ),
              ListTile(
                  title: Material(
                      type: MaterialType.transparency,
                      child: Text(title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ))),
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
