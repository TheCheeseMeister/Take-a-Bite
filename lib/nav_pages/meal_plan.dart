import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:take_a_bite/globals.dart' as globals;

List<String> breakfast = [];
List<String> lunch = [];
List<String> dinner = [];
List<String> snack = [];

class MealPlan extends StatelessWidget {
  const MealPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return
        //body: Center(child: Text("Meal Plan Page")),
        DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            // title moves it higher, bottom looks neater
            tabs: [
              // Represents week planner
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Icon(Icons.shopping_cart),
              ),
              // Represents ingredient list
              Padding(
                padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Icon(Icons.egg),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ShoppingList(),
            Text("Ingredients List"),
          ],
        ),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final timeController = TextEditingController();
  String currTime = "";

  Future<int> createMealPlan(String time) async {
    var url = Uri.http('3.93.61.3', '/api/feed/mealPlan/store');
    var response = await http.post(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        'date_to_make': DateTime.now().toString().split(" ")[0],
        'time_to_make': time.toLowerCase(),
      }),
    );

    print(response.statusCode);
    final mealPlanId = jsonDecode(response.body)['id'];
    return mealPlanId;
  }

  Future<void> createMealPlanLink(
      int user_id, int recipe_id, int mealplan_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/mealPlanLink/store');
    var response = await http.post(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        'mur_user_id': user_id,
        'mur_recipe_id': recipe_id,
        'mur_mealplan_id': mealplan_id
      }),
    );

    print(response.statusCode);
  }

  Future<void> refreshCreatedRecipes() async {
    var url = Uri.http(
        '3.93.61.3', '/api/feed/userRecipes/${globals.user['user_id']}');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );
    final data = jsonDecode(response.body)['user_recipes'];

    setState(() {
      globals.createdRecipes = data;
    });
  }

  Future<void> refreshSavedRecipes() async {
    var url = Uri.http('3.93.61.3',
        '/api/feed/getUserSavedRecipes/${globals.user['user_id']}');
    var response = await http.get(url, headers: {
      "Authorization": 'Bearer ${globals.token}',
      "Accept": "application/json"
    });

    final data = jsonDecode(response.body)['recipes'];

    setState(() {
      globals.savedRecipes = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 24, 0),
            child: IconButton(
              onPressed: () async {
                await refreshCreatedRecipes();
                await refreshSavedRecipes();

                // Created and Saved Recipes put together for Dropdown
                List<dynamic> combinedRecipes = [
                  ...globals.createdRecipes,
                  ...globals.savedRecipes
                ];

                setState(() {
                  currTime = DateTime.now().toString().split(" ")[0];
                });

                if (!context.mounted) return;

                List<String> temp = currTime.split("-");
                String title = "${temp[1]}/${temp[2]}/${temp[0]}";

                setState(() {
                  breakfast.clear();
                  lunch.clear();
                  dinner.clear();
                  snack.clear();
                });
                
                print(breakfast);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Dialog(
                          child: SingleChildScrollView(
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 36),
                                  Text(
                                    "Meal Plan - $title",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                  DropdownSearch<String>.multiSelection(
                                    dropdownBuilder: (context, breakfast) {
                                      return Wrap(
                                        children: breakfast
                                            .map(
                                              (item) => Chip(
                                                label: Text(
                                                  item,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  softWrap:
                                                      true,
                                                ),
                                                deleteIcon:
                                                    const Icon(Icons.clear),
                                                onDeleted: () {
                                                  setState(() {
                                                    breakfast.remove(item);
                                                  });
                                                  print(breakfast);
                                                },
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                    selectedItems: breakfast,
                                    items: (filter, s) => combinedRecipes
                                        .map<String>(
                                            (recipe) => recipe['recipe_name'])
                                        .toList(),
                                    compareFn: (i, s) => i == s,
                                    onChanged: (List<String> selectedItems) {
                                      setState(() {
                                        breakfast = selectedItems;
                                      });
                                    },
                                    decoratorProps:
                                        const DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Breakfast",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      menuProps: const MenuProps(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      showSearchBox: true,
                                      constraints: const BoxConstraints(
                                          maxWidth: 600, maxHeight: 200),
                                      itemBuilder: (context, item, isDisabled,
                                          isSelected) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0, 0, 0),
                                          child: Text(item.toString()),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    dropdownBuilder: (context, lunch) {
                                      return Wrap(
                                        children: lunch
                                            .map(
                                              (item) => Chip(
                                                label: Text(
                                                  item,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  softWrap:
                                                      true,
                                                ),
                                                deleteIcon:
                                                    const Icon(Icons.clear),
                                                onDeleted: () {
                                                  setState(() {
                                                    lunch.remove(item);
                                                  });
                                                },
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                    selectedItems: lunch,
                                    items: (filter, s) => combinedRecipes
                                        .map<String>(
                                            (recipe) => recipe['recipe_name'])
                                        .toList(),
                                    compareFn: (i, s) => i == s,
                                    onChanged: (List<String> selectedItems) {
                                      setState(() {
                                        lunch = selectedItems;
                                      });
                                    },
                                    decoratorProps:
                                        const DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Lunch",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      menuProps: const MenuProps(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      showSearchBox: true,
                                      constraints: const BoxConstraints(
                                          maxWidth: 500, maxHeight: 200),
                                      itemBuilder: (context, item, isDisabled,
                                          isSelected) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0, 0, 0),
                                          child: Text(item.toString()),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    dropdownBuilder: (context, dinner) {
                                      return Wrap(
                                        children: dinner
                                            .map(
                                              (item) => Chip(
                                                label: Text(
                                                  item,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  softWrap:
                                                      true,
                                                ),
                                                deleteIcon:
                                                    const Icon(Icons.clear),
                                                onDeleted: () {
                                                  setState(() {
                                                    dinner.remove(item);
                                                  });
                                                },
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                    selectedItems: dinner,
                                    items: (filter, s) => combinedRecipes
                                        .map<String>(
                                            (recipe) => recipe['recipe_name'])
                                        .toList(),
                                    compareFn: (i, s) => i == s,
                                    onChanged: (List<String> selectedItems) {
                                      setState(() {
                                        dinner = selectedItems;
                                      });
                                    },
                                    decoratorProps:
                                        const DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Dinner",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      menuProps: const MenuProps(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      showSearchBox: true,
                                      constraints: const BoxConstraints(
                                          maxWidth: 500, maxHeight: 200),
                                      itemBuilder: (context, item, isDisabled,
                                          isSelected) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0, 0, 0),
                                          child: Text(item.toString()),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  DropdownSearch<String>.multiSelection(
                                    dropdownBuilder: (context, snack) {
                                      return Wrap(
                                        children: snack
                                            .map(
                                              (item) => Chip(
                                                label: Text(
                                                  item,
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                  softWrap:
                                                      true,
                                                ),
                                                deleteIcon:
                                                    const Icon(Icons.clear),
                                                onDeleted: () {
                                                  setState(() {
                                                    snack.remove(item);
                                                  });
                                                },
                                              ),
                                            )
                                            .toList(),
                                      );
                                    },
                                    items: (filter, s) => combinedRecipes
                                        .map<String>(
                                            (recipe) => recipe['recipe_name'])
                                        .toList(),
                                    compareFn: (i, s) => i == s,
                                    onChanged: (List<String> selectedItems) {
                                      setState(() {
                                        snack = selectedItems;
                                      });
                                    },
                                    decoratorProps:
                                        const DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Snack",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    popupProps: PopupPropsMultiSelection.menu(
                                      menuProps: const MenuProps(
                                          backgroundColor: Color.fromARGB(
                                              255, 255, 255, 255)),
                                      showSearchBox: true,
                                      constraints: const BoxConstraints(
                                          maxWidth: 500, maxHeight: 200),
                                      itemBuilder: (context, item, isDisabled,
                                          isSelected) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 0, 0, 0),
                                          child: Text(item.toString()),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                  // insert text for validation; needs at least one recipe selected.
                                  ElevatedButton(
                                    onPressed: () async {
                                      int plan_id = await createMealPlan(
                                          timeController.text);
                                      //await createMealPlanLink(globals.user['user_id'], selectedRecipe['id'], plan_id);

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Create Meal Plan"),
                                  ),
                                  const SizedBox(
                                    height: 36,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.add),
            )),
      ),
      const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("No Meal Plans..."),
        ],
      )
    ]);
  }
}
