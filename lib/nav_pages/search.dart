import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/fake_instruct.dart';
import './recipe.dart';

import 'package:dropdown_search/dropdown_search.dart';

import 'package:take_a_bite/globals.dart' as globals;

List<Map<String, dynamic>> recipes =
    []; // Different recipes that will be displayed as cards

List<dynamic> newRecipeList = [];

List<List<dynamic>> ingredients =
    []; // Ingredients of recipe in foreign key format
List<Map<String, dynamic>> recipeIngredients =
    []; // Ingredients of recipe in human readable format
List<Map<String, dynamic>> recipeTags = [];
bool searching = false; // Currently querying for recipes (loading symbol)

List<String> selectedIngredients = []; // Selected ingredients in dropdown
List<String> selectedTags = []; // Selected tags in dropdown
final wordSearch = TextEditingController(); // Search recipe name

// TODO: make StatefulWidget to allow setting of values
class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  Future<void> getRecipes() async {
    setState(() {
      recipes.clear();
    });

    var url = Uri.http('3.93.61.3', '/api/feed/recipe');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    var data = jsonDecode(response.body)['recipe_name'];
    //data.shuffle(); Use this for randomizing order
    data = data.reversed.toList();

    print(data);

    print(response.statusCode);
    //print(data[0]);

    for (var i = 0; i < 25; i++) {
      setState(() {
        recipes.add(data[i]);
      });
    }
  }

  Future<void> getRecipeIngredients(int recipe_id) async {
    if (recipe_id == 970) print("WHAT");
    var url = Uri.http('3.93.61.3', '/api/feed/recipeIngredient/$recipe_id');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    final data = jsonDecode(response.body)['ingredients'];
    setState(() {
      ingredients.add(data);
    });
    //print(recipe_id);
  }

  Future<void> getRecipeTags(int recipe_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/tagRecipe/$recipe_id');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    final data = jsonDecode(response.body)['ingredients'];
    if (data.isEmpty) {
      Map<String, dynamic> empty = {};
      setState(() {
        recipeTags.add(empty);
      });
    } else {
      List<dynamic> tagIds = data.map((e) => e['tags_id']).toList();
      //print(tagIds);
      List<dynamic> tags = globals.tagsList
          .where((element) => tagIds.contains(element['tags_id']))
          .map((element) => element['tag_name'])
          .toList();
      //print(tags);
      Map<String, dynamic> temp = {"id": recipe_id, "tags": tags};

      setState(() {
        recipeTags.add(temp);
      });
    }
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
          var ingredient_id = r_ingredients[i]['ri_ingredient_id'] - 1;
          var ingredient_name =
              globals.ingredientsList[ingredient_id]['ingredient_name'];
          var portion = r_ingredients[i]['ri_ingredient_measurement'];

          ingredient_info['ingredient_name'] = ingredient_name;
          ingredient_info['portion'] = portion;
          recipe_ingredients['$ingredient_id'] = ingredient_info;
        }

        recipe['ingredients'] = recipe_ingredients;

        recipeIngredients.add(recipe);
        //print(recipe);
      }
    }
    //print(recipeIngredients.firstWhere((e) => e['recipe_id'] == 1035, orElse: () => {})['ingredients']);
  }

  // Enforce selectedIngredients, remove repices without these ingredients
  void enforceIngredients() {
    for (var ingredient in selectedIngredients) {
      newRecipeList = newRecipeList.where((recipe) {
        var ingredientList = recipe['ingredients']
            .map((ingredient) => ingredient['ingredient_name']);
        return ingredientList.contains(ingredient);
      }).toList();
      /*recipes = recipes.where((recipe) {
        var tempIngredients = recipeIngredients.firstWhere(
            (e) => e['recipe_id'] == recipe['recipe_id'],
            orElse: () => {})['ingredients'];
        if (tempIngredients == {}) return false;
        if (tempIngredients != null) {
          List<dynamic> tempIngredientNames = tempIngredients.values
              .map((e) => e['ingredient_name'] ?? '')
              .toList();
          return tempIngredientNames.contains(ingredient);
        }
        return false;
      }).toList();*/
    }
  }

  void enforceTags() {
    for (var tag in selectedTags) {
      newRecipeList = newRecipeList.where((recipe) {
        var tagsList = recipe['tags'].map((tag) => tag['tag_name']).toList();
        return tagsList.contains(tag);
      }).toList();
      /*recipes = recipes.where((recipe) {
        var tempTags = recipeTags.firstWhere(
            (e) => e['id'] == recipe['recipe_id'],
            orElse: () => {});
        if (tempTags == {}) return false;
        if (tempTags != null) {
          List<dynamic> tempTagList = tempTags['tags'] ?? [];
          if (tempTagList == []) return false;
          return tempTagList.contains(tag);
        }
        return false;
      }).toList();*/
    }
  }

  void enforceSearch() {
    /*var query = wordSearch.text.toLowerCase();
    recipes = recipes.where((recipe) {
      return recipe['recipe_name'].toLowerCase().contains(query);
    }).toList();*/
    var query = wordSearch.text.toLowerCase();
    newRecipeList = newRecipeList.where((recipe) {
      return recipe['recipe_name'].toLowerCase().contains(query);
    }).toList();
  }

  // Attempt to speed up Search
  Future<void> getRecipesTest() async {
    var url = Uri.http('3.93.61.3', '/api/feed/getRecipesAndInfo');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Accept-Encoding": "identity",
      },
    );

    final data = jsonDecode(response.body)['user_recipes'].reversed.toList();

    print(response.statusCode);

    setState(() {
      newRecipeList = data;
    });
  }

  // Search method for SearchBar, sends callback to parent widget (this)
  Future<void> handleSearch() async {
    FocusScope.of(context).unfocus();

    setState(() {
      searching = true;
    });

    await getRecipesTest();

    print(newRecipeList.length);

    enforceIngredients();
    enforceTags();
    enforceSearch();

    print(newRecipeList.length);

    //enforceTags();
    //enforceSearch();
    //await getRecipes();

    //await getRecipesTest();
    //print(globals.token);

    //print(recipes.length);

    //print("1");
    //await getRecipes();

    /*setState(() {
      ingredients = [];
    });
    setState(() {
      recipeTags = [];
    });

    print("2");

    for (var recipe in recipes) {
      await getRecipeIngredients(recipe['recipe_id']);
      await getRecipeTags(recipe['recipe_id']);
    }

    print("3");

    buildRecipeIngredients();

    // filter
    enforceIngredients();
    enforceTags();
    enforceSearch();
*/
    setState(() {
      if (newRecipeList.length < 10) {
        recipeViewCount = newRecipeList.length;
      } else {
        recipeViewCount = 10;
      }
    });

    setState(() {
      searching = false;
    });

    //print(globals.tagsList);
  }

  int recipeViewCount = -1;
  final recipeScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    recipeScrollController.addListener(() {
      if (recipeScrollController.position.atEdge && recipeViewCount != -1) {
        bool isTop = recipeScrollController.position.pixels == 0;
        if (!isTop) {
          incrementViewCount();
        }
      }
    });
  }

  void incrementViewCount() async {
    await Future.delayed(const Duration(milliseconds: 250));
    // TODO: change depending on whether length is < 10 more
    if (recipeViewCount + 10 > (newRecipeList.length)) {
      setState(() {
        recipeViewCount += (newRecipeList.length - recipeViewCount);
      });
    }
    else {
      setState(() {
        recipeViewCount += 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: recipeScrollController,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 282,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 48, 0, 0),
                            child: TextField(
                              controller: wordSearch,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Search",
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: SearchBar(),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: TagSearchBar(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 8, 64),
                      child: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () async {
                          //await widget.searchMethod();
                          await handleSearch();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              searching
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
                      child: CircularProgressIndicator(),
                    )
                  : newRecipeList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Text("No Results."),
                        )
                      : ListView.builder(
                          //controller: recipeScrollController,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: recipeViewCount + 1,
                          itemBuilder: (context, index) {
                            if (index < recipeViewCount) {
                              return RecipeCard(
                                  recipeInfo: newRecipeList[index],
                                  index: index + 1000);
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 36, 0, 36),
                                child: Center(
                                  child: recipeViewCount == newRecipeList.length
                                      ? const Text("End of Results",
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic))
                                      : const CircularProgressIndicator(),
                                ),
                              );
                            }
                          }),
              /*ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(newRecipeList.length, (index) {
                            return RecipeCard(
                                recipeInfo: newRecipeList[index],
                                index: index + 1000);
                          }),
                        ),*/
              /*recipes.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
                          child: Text("No Results."),
                        )
                      : ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(recipes.length, (index) {
                            return RecipeCard(
                                recipeInfo: recipes[index],
                                index: index + 1000);
                          }),
                        ),*/
            ],
          ),
        ),
      ),
    );
  }
}

// Search Bar (uses Dropdown_Search package)
class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
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
            width: 266,
            child: DropdownSearch<String>.multiSelection(
              dropdownBuilder: (context, selectedItems) {
                return Wrap(
                  children: selectedItems
                      .map(
                        (item) => Chip(
                          label: Text(
                            item,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow
                                .ellipsis, // This is for overflow handling
                            softWrap:
                                true, // This enables wrapping of text in Chip
                          ),
                          deleteIcon: const Icon(Icons.clear),
                          onDeleted: () {
                            setState(() {selectedItems.remove(item);});
                          },
                        ),
                      )
                      .toList(),
                );
              },
              items: (filter, s) => globals.ingredientsList
                  .map<String>((ingredient) => ingredient['ingredient_name'])
                  .toList(),
              compareFn: (i, s) => i == s,
              onChanged: (List<String> selectedItems) {
                // TODO: add httprequest to search for recipes with selected items
                setState(() {
                  selectedIngredients = selectedItems;
                });
              },
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Ingredients",
                  border: OutlineInputBorder(),
                ),
              ),
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
      ],
    );
  }
}

class TagSearchBar extends StatefulWidget {
  const TagSearchBar({super.key});

  @override
  State<TagSearchBar> createState() => _TagSearchBarState();
}

class _TagSearchBarState extends State<TagSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: SizedBox(
            width: 266,
            child: DropdownSearch<String>.multiSelection(
              dropdownBuilder: (context, selectedItems) {
                return Wrap(
                  children: selectedItems
                      .map(
                        (item) => Chip(
                          label: Text(
                            item,
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow
                                .ellipsis, // This is for overflow handling
                            softWrap:
                                true, // This enables wrapping of text in Chip
                          ),
                          deleteIcon: const Icon(Icons.clear),
                          onDeleted: () {
                            setState(() {selectedItems.remove(item);});
                          },
                        ),
                      )
                      .toList(),
                );
              },
              items: (filter, s) => globals.tagsList
                  .map<String>((tag) => tag['tag_name'])
                  .toList(),
              compareFn: (i, s) => i == s,
              onChanged: (List<String> selectedItems) {
                // TODO: add httprequest to search for recipes with selected items
                setState(() {
                  selectedTags = selectedItems;
                });
              },
              decoratorProps: const DropDownDecoratorProps(
                decoration: InputDecoration(
                  labelText: "Tags",
                  border: OutlineInputBorder(),
                ),
              ),
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
      ],
    );
  }
}

// Recipe displayed on Search Page
class RecipeCard extends StatefulWidget {
  final Map<String, dynamic> recipeInfo;
  final int index;

  RecipeCard({
    super.key,
    required this.recipeInfo,
    required this.index,
  });

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  String authorName = "";
  String authorBio = "";
  String authorPicture = "";

  Future<void> getUser(int user_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/getUser/$user_id');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    var data = jsonDecode(response.body)['user'];

    setState(() {
      authorName = data['user_username'];
      authorBio = data['user_bio'] ?? "";
      authorPicture = data['user_profile_picture'] ?? "";
    });
    print(authorPicture);
    print(globals.savedRecipes);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.recipeInfo['recipe_name'];
    String image = widget.recipeInfo['recipe_image'] ?? "";
    String prepTime = widget.recipeInfo['prep_time'];
    String cookTime = widget.recipeInfo['cook_time'];
    String servingSize = widget.recipeInfo['recipe_servings'];
    String description = widget.recipeInfo['recipe_directions'];

    bool isVegan = false;
    bool isGlutenFree = false;

    var tempIngredients = newRecipeList.where((element) => element['recipe_id'] == widget.recipeInfo['recipe_id']).first['ingredients'];

    int index = 0;
    Map<String, dynamic> ingredients = {};
    ingredients['recipe_id'] = widget.recipeInfo['recipe_id'];

    var tempMap = {};
    for (var ingredient in tempIngredients) {
      var tempInfo = {};
      tempInfo['ingredient_name'] = ingredient['ingredient_name'];
      tempInfo['portion'] = ingredient['portion'];
      tempMap[index] = tempInfo;

      index++;
    }

    ingredients['ingredients'] = tempMap;

    Map<String, dynamic> tempTags = recipeTags.firstWhere(
        (element) => element['id'] == widget.recipeInfo['recipe_id'],
        orElse: () => {});
    
    var tags = newRecipeList.where((element) => element['recipe_id'] == widget.recipeInfo['recipe_id']).first['tags'];
    tags = tags.map((tag) => tag['tag_name']).toList();
    
    if (tags.isNotEmpty) {
      if (tags.contains('vegan')) {
        isVegan = true;
      }

      if (tags.contains('gluten-free')) {
        isGlutenFree = true;
      }
    }

    Image? img = null;

    if (image != "") {
      img = Image.network(image,
          width: double.infinity, height: 300, fit: BoxFit.cover);
    }

    return FractionallySizedBox(
      widthFactor: 0.9,
      child: InkWell(
        onTap: () async {
          await getUser(widget.recipeInfo['user_user_id']);

          if (!context.mounted) return;

          PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
            context,
            settings: const RouteSettings(),
            screen: RecipePage(
                recipeInfo: widget.recipeInfo,
                ingredients: ingredients,
                image: image,
                isVegan: isVegan,
                isGlutenFree: isGlutenFree,
                authorName: authorName,
                authorBio: authorBio,
                authorPicture: authorPicture,
                index: widget.index),
            withNavBar: true,
            pageTransitionAnimation: PageTransitionAnimation.fade,
          );
        },
        child: Card(
          child: Column(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Hero(
                    tag: 'recipe-${widget.index}',
                    child: image != ""
                        ? img!
                        : const Icon(
                            Icons.image_not_supported,
                            size: 300,
                            color: Colors.grey,
                          ),
                  )),
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
