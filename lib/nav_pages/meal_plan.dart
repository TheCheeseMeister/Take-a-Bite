import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:take_a_bite/globals.dart' as globals;

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
    var response = await http.post(url,
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

  Future<void> createMealPlanLink(int user_id, int recipe_id, int mealplan_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/mealPlanLink/store');
    var response = await http.post(url,
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

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 24, 0),
          child: IconButton(
            onPressed: () {
              setState(() {
                currTime = DateTime.now().toString().split(" ")[0];
              });

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Current Date: $currTime"),
                          const SizedBox(
                            height: 16,
                          ),
                          DropdownMenu(
                            controller: timeController,
                            hintText: "Time of Day",
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(
                                value: "breakfast",
                                label: "Breakfast",
                              ),
                              DropdownMenuEntry(
                                value: "lunch",
                                label: "Lunch",
                              ),
                              DropdownMenuEntry(
                                value: "dinner",
                                label: "Dinner",
                              ),
                              DropdownMenuEntry(
                                value: "snack",
                                label: "Snack",
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              int plan_id = await createMealPlan(timeController.text);
                              //await createMealPlanLink(globals.user['user_id'], selectedRecipe['id'], plan_id);

                              Navigator.of(context).pop();
                            },
                            child: const Text("Create Meal Plan"),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: const Icon(Icons.add),
          )
        ),
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
