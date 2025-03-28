import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/fake_instruct.dart';
import 'package:take_a_bite/nav_pages/recipe.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 56, 0, 0),
              child: ProfileHead(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: ProfileDescription(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: RecipeList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Includes Profile Picture, Display Name, Username, Followers and Created Recipes
class ProfileHead extends StatelessWidget {
  const ProfileHead({super.key});

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
          child: const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('lib/imgs/cheeseprofile.PNG'),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("CheeseLover",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                )),
            Text("@CheeseBros",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14,
                )),
            Text(
              "0 Followers  0 Recipes",
              style: TextStyle(
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
  const ProfileDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 250, maxWidth: 250),
      child: const Text(
        "Cooking Legend.\nSeeking cheese recipes night and day.\n#CheeseLovers25",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Will list created or saved recipes depending on which is selected. Defaults to created.
class RecipeList extends StatefulWidget {
  const RecipeList({super.key});

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
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
                  children: List.generate(200, (index) {
                    return ProfileRecipe(index: index);
                  }),
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
class ProfileRecipe extends StatelessWidget {
  ProfileRecipe({super.key, required this.index});

  // Contains same info as Recipe Cards from Search Page (will have description and recipe creator)
  final String title = "How to make a pizza in 10 minutes";
  final Image image = const Image(image: AssetImage('lib/imgs/pizza.jpg'));
  final int prepTime = 10;
  final int cookTime = 10;
  final String servingSize = "4 - 5 people";
  final int index;
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
              prepTime: prepTime,
              cookTime: cookTime,
              servingSize: servingSize,
              instructions: description,
              index: index),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.fade,
        ),
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
                tag: "recipe-$index",
                child: image,
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
