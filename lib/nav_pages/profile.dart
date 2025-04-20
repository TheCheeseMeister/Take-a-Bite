import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/fake_instruct.dart';
import 'package:take_a_bite/nav_pages/recipe.dart';
import 'package:take_a_bite/globals.dart' as globals;

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
    required this.profileImage,
    required this.displayName,
    required this.username,
    required this.followers,
    required this.recipes,
    required this.bio,
  }) : super(key: key);
  
  final String profileImage;
  final String displayName;
  final String username;
  final int followers;
  final int recipes;
  final String bio;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool update = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 56, 0, 0),
              child: ProfileHead(
                profileImage: widget.profileImage,
                displayName: widget.displayName,
                username: widget.username,
                followers: widget.followers,
                recipes: widget.recipes,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ProfileDescription(
                bio: widget.bio,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: RecipeList(update: update),
            ),
          ],
        ),
      ),
    );
  }
}

// Includes Profile Picture, Display Name, Username, Followers and Created Recipes
class ProfileHead extends StatelessWidget {
  const ProfileHead({
    super.key,
    required this.profileImage,
    required this.displayName,
    required this.username,
    required this.followers,
    required this.recipes,
  });
  
  final String profileImage;
  final String displayName;
  final String username;
  final int followers;
  final int recipes;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  blurRadius: 2,
                  color: Color.fromARGB(255, 107, 107, 107),
                  spreadRadius: 1)
            ],
          ),
          child: CircleAvatar(
            radius: 50,
            //backgroundImage: AssetImage('lib/imgs/cheeseprofile.PNG'),
            backgroundImage: AssetImage(profileImage),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              //"CheeseLover",
              displayName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )
            ),
            Text(
              //"@CheeseBros",
              username,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
              )
            ),
            Text(
              //"0 Followers  0 Recipes",
              "$followers Followers  $recipes Recipes",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// Description for profile
class ProfileDescription extends StatelessWidget {
  const ProfileDescription({
    super.key,
    required this.bio,
  });

  final String bio;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 250),
      child: Text(
        //"Cooking Legend.\nSeeking cheese recipes night and day.\n#CheeseLovers25",
        bio,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Will list created or saved recipes depending on which is selected. Defaults to created.
class RecipeList extends StatefulWidget {
  const RecipeList({super.key, required this.update});

  // fake update to refresh page
  final bool update;

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  /*void getRecipeLists(int user_id) async {
    List<dynamic> tempCreated = await getCreatedRecipes(user_id);
    setState(() {createdRecipes = tempCreated;});
  }*/

  @override
  void initState() {
    super.initState();
    //int user_id = globals.user['user_id'];
    //getRecipeLists(user_id);
  }

  @override
  Widget build(BuildContext context) {
    //print(createdRecipes);

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "Created",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Text(
                  "Saved",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height:
                363, // Maybe find some way to be dynamic? Can't not have set height or TabBarView doesn't display.
            child: TabBarView(
              children: [
                // First tab: Created Recipes
                GridView.count( 
                  childAspectRatio: 1,
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: globals.createdRecipes.asMap().entries.map((recipe) {
                    int index = recipe.key;
                    var item = recipe.value;
                    return ProfileRecipe(index: index+1, recipe: item);
                  }).toList().reversed.toList(),
                ),
                // Second tab: Saved Recipes
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List.generate(100, (index) {
                    return Center(
                      child: Text(
                        'Item $index',
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Created/Saved Recipes
class ProfileRecipe extends StatefulWidget {
  ProfileRecipe({super.key, required this.index, required this.recipe});

  final Map<String, dynamic> recipe; // recipeInfo
  final int index; 

  @override
  State<ProfileRecipe> createState() => _ProfileRecipeState();
}

class _ProfileRecipeState extends State<ProfileRecipe> {
  // Contains same info as Recipe Cards from Search Page (will have description and recipe creator)
  final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));
  final List<String> ingredients = fakeIngredients();
 // index
  String description = fakeInstructions();

  Future<Map<String, dynamic>> getRecipeIngredients(int recipe_id) async {
    //print(recipe_id);
    var url = Uri.http('3.93.61.3', '/api/feed/recipeIngredient/$recipe_id');
    var response = await http.get(url,
        headers: {
          "Authorization": 'Bearer ${globals.token}',
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
    );
    final data = jsonDecode(response.body)['ingredients'];
    //print(data);
    var temp = data.map((e) => [e['ri_ingredient_id'], e['ri_ingredient_measurement']]).toList();
    //print(temp);
    
    Map<String, dynamic> value = {};
    value['recipe_id'] = recipe_id;

    Map<String, dynamic> tempMap = {};
    for (var ingredient in temp) {
      var i = globals.ingredientsList.firstWhere((e) => e['ingredient_id'] == ingredient[0])['ingredient_name'];
      tempMap[(ingredient[0]-1).toString()] = {'ingredient_name': i, 'portion': ingredient[1]};
    }

    value['ingredients'] = tempMap;
    
    return value;
  }

  Future<List<Map<String, dynamic>>> getRecipeTags(int recipe_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/tagRecipe/$recipe_id');
    var response = await http.get(url,
        headers: {
          "Authorization": 'Bearer ${globals.token}',
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
    );
    final data = jsonDecode(response.body)['ingredients'];
    List<Map<String, dynamic>> recipeTags = [];
    if (data.isEmpty) {
      Map<String, dynamic> empty = {};
      recipeTags.add(empty);
    } else {
      List<dynamic> tagIds = data.map((e) => e['tags_id']).toList();
      //print(tagIds);
      List<dynamic> tags = globals.tagsList.where((element) => tagIds.contains(element['tags_id'])).map((element) => element['tag_name']).toList();
      //print(tags);
      Map<String, dynamic> temp = {"id": recipe_id, "tags": tags};
      
      recipeTags.add(temp);
    }
    return recipeTags;
  }

  @override
  Widget build(BuildContext context) {
    int recipe_id = widget.recipe['recipe_id'];
    String title = widget.recipe['recipe_name'];
    
    Image? image = widget.recipe['recipe_image'] == null ? null : Image.network(widget.recipe['recipe_image'], width: double.infinity, height: 100, fit: BoxFit.cover);

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: InkWell(
        onTap: () async {
          Map<String, dynamic> ingredients = await getRecipeIngredients(recipe_id);
          print(ingredients);
          List<Map<String, dynamic>> tags = await getRecipeTags(recipe_id);
          print(tags);

          bool isVegan = false;
          bool isGlutenFree = false;

          if (tags.contains('vegan')) isVegan = true;
          if (tags.contains('gluten-free')) isGlutenFree = true;

          if (!context.mounted) return;

          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            context,
            settings: const RouteSettings(),
            screen: RecipePage(
                recipeInfo: widget.recipe,
                ingredients: ingredients,
                image: widget.recipe['recipe_image'],
                isVegan: isVegan,
                isGlutenFree: isGlutenFree,
                index: widget.index),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        },
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              // Might have to change depending on picture used for recipe, but works for now.
              child: Hero(
                tag: "recipe-${widget.index}",
                child: image == null
                ? const Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                )
                : image!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,4,0,0),
              child: FractionallySizedBox(
                widthFactor: 0.95,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
