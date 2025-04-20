import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/globals.dart' as globals;
import 'package:take_a_bite/nav_pages/others_profile.dart';
import 'package:take_a_bite/nav_pages/profile.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({
    super.key,
    /*required this.image,
    required this.title,
    required this.ingredients,
    required this.prepTime,
    required this.cookTime,
    required this.servingSize,
    required this.instructions,
    required this.index,*/
    required this.recipeInfo,
    required this.ingredients,
    required this.image,
    required this.isVegan,
    required this.isGlutenFree,
    required this.authorName,
    required this.authorBio,
    required this.authorPicture,
    required this.index,
  });

  // Info passed from Recipe Card
  final Map<String, dynamic> recipeInfo;
  final Map<String, dynamic> ingredients;
  final String? image;
  final bool isVegan;
  final bool isGlutenFree;
  final String authorName;
  final String? authorBio;
  final String? authorPicture;
  final int index; 
  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
 // For hero
  @override
  Widget build(BuildContext context) {
    String title = widget.recipeInfo['recipe_name'];
    String prepTime = widget.recipeInfo['prep_time'];
    String cookTime = widget.recipeInfo['cook_time'];
    String servingSize = widget.recipeInfo['recipe_servings'];
    String instructions = widget.recipeInfo['recipe_directions'];
    String subtitle = widget.recipeInfo['recipe_description'];

    timeDilation = 0.5;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'recipe-${widget.index}',
              child: widget.image == "" || widget.image == null
              ? const Icon(
                        Icons.image_not_supported,
                        size: 300,
                        color: Colors.grey,
                      )
              : Image.network(widget.image!),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(36,0,0,0),
              child: Row(
                children: [
                  if (widget.isVegan) 
                    const Chip(
                      label: Text("Vegan", style: TextStyle(fontSize: 12)),
                      shape: StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 129, 212, 121),
                    ),
                  if (widget.isVegan && widget.isGlutenFree)
                    const SizedBox(
                      height: 20,
                      width: 8,
                    ),
                  if (widget.isGlutenFree) 
                    const Chip(
                      label: Text("Gluten-Free", style: TextStyle(fontSize: 12)),
                      shape: StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 255, 212, 82),
                    ),
                ],
              ),
            ),
            const Divider(
              height: 2,
              indent: 40,
              endIndent: 40,
              thickness: 2,
              color: Colors.black,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: Text(
                "Required Ingredients",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            // This is where ingredients list goes
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 24),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Column(
                    children: widget.ingredients['ingredients'] != null
                    ? widget.ingredients['ingredients'].entries.map<Widget>((e) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Text(
                          "${e.value['portion']} ${e.value['ingredient_name']}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList()
                    : [
                      Text("No Ingredients."),
                    ],
                  ),
                ),
              ),
            ),
            // Prep Time, Cook Time, Serving Size
            RecipeStats(
                prepTime: prepTime,
                cookTime: cookTime,
                servingSize: servingSize),
            // Description / instructions
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: Divider(
                height: 2,
                indent: 40,
                endIndent: 40,
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Text(
                  instructions,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 24),
              child: Divider(
                height: 2,
                indent: 20,
                endIndent: 20,
                thickness: 1,
                color: Color.fromARGB(255, 168, 168, 168),
              ),
            ),
            // Poster's profile (i.e. Made by CheeseMaster) / Likes? Or maybe Likes higher
            //Text("Insert creator profile here"),
            RecipeCreator(authorName: widget.authorName, profileImage: widget.authorPicture, authorId: widget.recipeInfo['user_user_id'], authorBio: widget.authorBio),
            const SizedBox(
              height: 50,
            ),
            // Comments (can go to poster's profile from comment)
            /*const Padding(
              padding: EdgeInsets.fromLTRB(0, 48, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20,0,0,0),
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 24),
                    child: Divider(
                      height: 2,
                      indent: 20,
                      endIndent: 20,
                      thickness: 1,
                      color: Color.fromARGB(255, 168, 168, 168),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

// Displays Recipe Creator and info, option to go to profile
class RecipeCreator extends StatefulWidget {
  const RecipeCreator({
    super.key,
    required this.authorName,
    required this.profileImage,
    required this.authorId,
    required this.authorBio
  });

  //final String profileImage = "lib/imgs/cheeseprofile.PNG";
  final String? profileImage;
  final String authorName;
  final int authorId;
  final String? authorBio;

  @override
  State<RecipeCreator> createState() => _RecipeCreatorState();
}

class _RecipeCreatorState extends State<RecipeCreator> {
  final int followers = 0;

  final int recipes = 0;

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getCreatedRecipes(int user_id) async {
      var url = Uri.http('3.93.61.3', '/api/feed/userRecipes/$user_id');
      var response = await http.get(url,
          headers: {
            "Authorization": 'Bearer ${globals.token}',
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
      );
      final data = jsonDecode(response.body)['user_recipes'];
      return data;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 24, 0),
          child: Container(
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
            child: InkWell(
              onTap: () async {
                List<dynamic> tempCreated = await getCreatedRecipes(widget.authorId);

                if (widget.authorId == globals.user['user_id']) {
                  setState(() {globals.createdRecipes = tempCreated;});

                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(),
                    screen: Profile(
                      //profileImage: profileImage,
                      displayName: widget.authorName,
                      username: "", // temporary fix to not break things
                      followers: followers,
                      recipes: recipes,
                      bio: widget.authorBio ?? "",
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                } else {
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(),
                    screen: OthersProfile(
                      //profileImage: profileImage,
                      displayName: widget.authorName,
                      username: "", // temporary fix to not break things
                      followers: followers,
                      recipes: recipes,
                      bio: widget.authorBio ?? "",
                      profilePicture: widget.profileImage ?? "",
                      createdRecipes: tempCreated,
                    ),
                    withNavBar: true,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                  );
                }
              }, 
              child: widget.profileImage != "" && widget.profileImage != null
              ? CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.profileImage!),
              )
              : CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Text(widget.authorName[0]),
              )
            ),
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "Written by",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 12,
            ),
          ),
          Text(
            widget.authorName,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          /*Text(
            "@CheeseBros",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),*/
        ]),
      ],
    );
  }
}

// Displays Prep time, Cook time, and Serving size
class RecipeStats extends StatelessWidget {
  const RecipeStats(
      {super.key,
      required this.prepTime,
      required this.cookTime,
      required this.servingSize});

  final String prepTime;
  final String cookTime;
  final String servingSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prep Time
        const Spacer(),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Prep Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '$prepTime mins')
            ],
          ),
        ),
        const Spacer(),
        // Cook Time
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Cook Time: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: '$cookTime mins')
            ],
          ),
        ),
        const Spacer(),
        // Serving Size
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(
                  text: 'Serving Size: ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: servingSize)
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
