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

  Future<List<dynamic>> createMealPlan(String date) async {
    var url = Uri.http('3.93.61.3', '/api/feed/mealPlan/store');
    var response = await http.post(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        'date_to_make': date,
      }),
    );

    print(response.statusCode);
    
    final data = jsonDecode(response.body)['plans'];
    return data;
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

  Future<void> refreshMealPlans() async {
    var url = Uri.http('3.93.61.3', '/api/feed/mealPlanLink/${globals.user['user_id']}');
    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
    );

    print(response.statusCode);
    
    final data = jsonDecode(response.body)['plans'];
    
    setState(() {plans = data;});

    await groupPlansByDate();

    /*print(plans);
    print(plans![0]);
    print(plans![0]['recipe']);
    print(plans![0]['recipe']['ingredients']);
    print(plans![0]['recipe']['ingredients'][0]);
    print(plans![0]['recipe']['ingredients'][0]['ingredient']);
    print(plans![0]['plan']);*/
  }

  Future<void> groupPlansByDate() async {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    if (plans!.isEmpty) {
      setState(() {datedPlans = {};});
      return;
    }

    for (var plan in plans!) {
      String date = plan['plan']['date_to_make'];

      if (grouped.containsKey(date)) {
        grouped[date]!.add(plan);
      } else {
        grouped[date] = [plan];
      }
    }

    setState(() {datedPlans = grouped;});
  }

  Map<String, List<Map<String, dynamic>>> groupPlansByTime(List<Map<String, dynamic>> items) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var item in items) {
      String time = item['plan']['time_to_make'];

      if (grouped.containsKey(time)) {
        grouped[time]!.add(item);
      } else {
        grouped[time] = [item];
      }
    }

    return grouped;
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

  List<dynamic>? plans;
  Map<String, List<Map<String, dynamic>>> datedPlans = {};

  void updatePlans(var item) {
    setState(() {plans!.add(item);});
  }

  @override
  void initState() {
    super.initState();
    refreshMealPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 24, 16, 0),
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
                    String selectedDate = DateTime.now().toString().split(" ")[0];
                    return StatefulBuilder(
                      builder: (context, setState) {
                        Future<void> openCalendar() async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365))
                          );

                          String date = pickedDate.toString().split(" ")[0];
                          setState(() {selectedDate = date;});
                          print(selectedDate);
                        }

                        return Dialog(
                          child: SingleChildScrollView(
                            child: FractionallySizedBox(
                              widthFactor: 0.9,
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 36),
                                  const Text(
                                    //"Meal Plan - $title",
                                    "Meal Plan",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 36),
                                  //Text("Selected Date: $selectedDate"),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: "Selected Date: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: selectedDate,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      openCalendar();
                                    },
                                    child: Text("Select Date"),
                                  ),
                                  const SizedBox(height: 24),
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
                                      List<dynamic> times = await createMealPlan(selectedDate);

                                      int breakfast_id = times[0]['plan']['meal_plan_id'];
                                      int lunch_id = times[1]['plan']['meal_plan_id'];
                                      int dinner_id = times[2]['plan']['meal_plan_id'];
                                      int snack_id = times[3]['plan']['meal_plan_id'];

                                      /*print(breakfast_id);
                                      print(lunch_id);
                                      print(dinner_id);
                                      print(snack_id);*/

                                      for (var recipe in breakfast) {
                                        var tempRecipeInfo = combinedRecipes.firstWhere((r) => r['recipe_name'] == recipe);
                                        int recipe_id = tempRecipeInfo['recipe_id'];
                                        await createMealPlanLink(globals.user['user_id'], recipe_id, breakfast_id);
                                      }

                                      for (var recipe in lunch) {
                                        var tempRecipeInfo = combinedRecipes.firstWhere((r) => r['recipe_name'] == recipe);
                                        int recipe_id = tempRecipeInfo['recipe_id'];
                                        await createMealPlanLink(globals.user['user_id'], recipe_id, lunch_id);
                                      }

                                      for (var recipe in dinner) {
                                        var tempRecipeInfo = combinedRecipes.firstWhere((r) => r['recipe_name'] == recipe);
                                        int recipe_id = tempRecipeInfo['recipe_id'];
                                        await createMealPlanLink(globals.user['user_id'], recipe_id, dinner_id);
                                      }

                                      for (var recipe in snack) {
                                        var tempRecipeInfo = combinedRecipes.firstWhere((r) => r['recipe_name'] == recipe);
                                        int recipe_id = tempRecipeInfo['recipe_id'];
                                        await createMealPlanLink(globals.user['user_id'], recipe_id, snack_id);
                                      }
                                      await refreshMealPlans();

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
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: plans == null
          ? [const CircularProgressIndicator()]
          : datedPlans.isEmpty 
          ? [const Text("No Meal Plans...")] 
          : [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 72, 0, 0),
                  child: ListView.builder(
                    itemCount: datedPlans.length,
                    itemBuilder: (context, index) {
                      String date = datedPlans.keys.elementAt(index);
                      List<Map<String, dynamic>> items = datedPlans[date]!;
                  
                      return ExpansionTile(
                        title: Text(date),
                        collapsedBackgroundColor: const Color.fromARGB(255, 211, 211, 211),
                        children: groupPlansByTime(items).entries.map((time) {
                          String time_to_make = time.key[0].toUpperCase() + time.key.substring(1);
                          List<dynamic> grouped = time.value;
                  
                          return ExpansionTile(
                            title: Text(time_to_make),
                            children: grouped.map((plan) {
                              return Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(16,0,0,0),
                                        child: Row(
                                          children: [
                                            Text(
                                              plan['recipe']['recipe_name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              plan['recipe']['cook_time'] + " | ",
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              plan['recipe']['recipe_servings'],
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                          ]
                                        ),
                                      ),
                                    ),
                                    // List ingredients of recipe
                                  ],
                                );
                            }).toList(),
                          );
                        }).toList(),
                      );
                    }
                  ),
                )
              )
          ],
      )
    ]);
  }
}
