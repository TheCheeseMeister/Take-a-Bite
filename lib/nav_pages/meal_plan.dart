import 'package:flutter/material.dart';

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
          title: const TabBar( // bottom moves it lower
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
            Text("Shopping List"),
            Text("Ingredients List"),
          ],
        ),
      ),
    );
  }
}
