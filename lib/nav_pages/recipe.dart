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
  Future<void> saveRecipe(int recipe_id) async {
    int user_id = globals.user['user_id'];

    var url = Uri.http('3.93.61.3', '/api/feed/userSaved');
    var response = await http.post(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "urs_user_id": user_id,
        "urs_recipe_id": recipe_id,
      }),
    );

    print(response.statusCode);
    print(response.body);
    //print(globals.createdRecipes);
  }

  Future<List<dynamic>> refreshSavedRecipes(int user_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/getUserSavedRecipes/$user_id');
    var response = await http.get(url, headers: {
      "Authorization": 'Bearer ${globals.token}',
      "Accept": "application/json"
    });

    final data = jsonDecode(response.body)['recipes'];

    return data;
  }

  Future<void> removeRecipe(int recipe_id) async {
    int user_id = globals.user['user_id'];

    var url = Uri.http('3.93.61.3', '/api/feed/removeUserSaved');
    var response = await http.post(
      url,
      headers: {
        "Authorization": 'Bearer ${globals.token}',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode({
        "urs_user_id": user_id,
        "urs_recipe_id": recipe_id,
      }),
    );

    print(response.statusCode);
    print(response.body);
    //print(globals.createdRecipes);
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.recipeInfo['recipe_name'];
    String prepTime = widget.recipeInfo['prep_time'];
    String cookTime = widget.recipeInfo['cook_time'];
    String servingSize = widget.recipeInfo['recipe_servings'];
    String instructions = widget.recipeInfo['recipe_directions'];
    String subtitle = widget.recipeInfo['recipe_description'] ?? "No Description.";

    timeDilation = 0.5;

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
            // User can't save their own recipe; User hasn't saved recipe yet.
            if (widget.recipeInfo['user_user_id'] != globals.user['user_id'] &&
                (globals.savedRecipes.isEmpty ||
                    globals.savedRecipes.any((recipe) =>
                        recipe['recipe_id'] != widget.recipeInfo['recipe_id'])))
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      // User can't save their own recipe
                      await saveRecipe(widget.recipeInfo['recipe_id']);
                      List<dynamic> tempSaved =
                          await refreshSavedRecipes(globals.user['user_id']);
                      globals.savedRecipes = tempSaved;
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 140, 199, 154),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    child: const Text(
                      "Save Recipe",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            // User already saved recipe; can remove recipe from saved.
            if (widget.recipeInfo['user_user_id'] != globals.user['user_id'] &&
                (globals.savedRecipes.any((recipe) =>
                    recipe['recipe_id'] == widget.recipeInfo['recipe_id'])))
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      // User can't save their own recipe
                      await removeRecipe(widget.recipeInfo['recipe_id']);
                      List<dynamic> tempSaved =
                          await refreshSavedRecipes(globals.user['user_id']);
                      globals.savedRecipes = tempSaved;
                      setState(() {});
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 228, 98, 98),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    child: const Text(
                      "Remove Recipe",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 24, 0),
                child: TextButton(
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String selectedDate =
                              DateTime.now().toString().split(" ")[0];
                          final planTimeSelection = TextEditingController();
                          String selectedTime = "breakfast";

                          return StatefulBuilder(builder: (context, setState) {
                            Future<void> openCalendar() async {
                              final DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)));

                              String date = pickedDate.toString().split(" ")[0];
                              setState(() {
                                selectedDate = date;
                              });
                            }

                            return Dialog(
                              child: FractionallySizedBox(
                                widthFactor: 0.9,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 24),
                                    const Text(
                                      "Add to Meal Plan",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
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
                                      child: const Text("Select Date"),
                                    ),
                                    const SizedBox(height: 24),
                                    DropdownMenu<String>(
                                      initialSelection: selectedTime,
                                      label: const Text("Time"),
                                      controller: planTimeSelection,
                                      onSelected: (String? time) {
                                        setState(() {
                                          selectedTime = time!;
                                        });
                                        print(selectedTime);
                                      },
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(
                                            value: "breakfast",
                                            label: "Breakfast"),
                                        DropdownMenuEntry(
                                            value: "lunch", label: "Lunch"),
                                        DropdownMenuEntry(
                                            value: "dinner", label: "Dinner"),
                                        DropdownMenuEntry(
                                            value: "snack", label: "Snack"),
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    ElevatedButton(
                                      onPressed: () async {
                                        List<dynamic> times = await createMealPlan(selectedDate);

                                        int breakfast_id = times[0]['plan']['meal_plan_id'];
                                        int lunch_id = times[1]['plan']['meal_plan_id'];
                                        int dinner_id = times[2]['plan']['meal_plan_id'];
                                        int snack_id = times[3]['plan']['meal_plan_id'];

                                        switch (selectedTime) {
                                          case 'breakfast':
                                            await createMealPlanLink(globals.user['user_id'], widget.recipeInfo['recipe_id'], breakfast_id);
                                            break;
                                          case 'lunch':
                                            await createMealPlanLink(globals.user['user_id'], widget.recipeInfo['recipe_id'], lunch_id);
                                            break;
                                          case 'dinner':
                                            await createMealPlanLink(globals.user['user_id'], widget.recipeInfo['recipe_id'], dinner_id);
                                            break;
                                          case 'snack':
                                            await createMealPlanLink(globals.user['user_id'], widget.recipeInfo['recipe_id'], snack_id);
                                            break;
                                          default:
                                        }

                                        globals.plansChanged.value++;

                                        print("GLOBAL VALUE: ${globals.plansChanged.value}");

                                        if (!context.mounted) return;

                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Add to Plan"),
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                ),
                              ),
                            );
                          });
                        });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 104, 214, 205),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  child: const Text("Add to Plan",
                      style: TextStyle(color: Colors.black)),
                ),
              ),
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
              padding: const EdgeInsets.fromLTRB(36, 0, 0, 16),
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
                      label:
                          Text("Gluten-Free", style: TextStyle(fontSize: 12)),
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
                        ? widget.ingredients['ingredients'].entries
                            .map<Widget>((e) {
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
            RecipeCreator(
                authorName: widget.authorName,
                profileImage: widget.authorPicture,
                authorId: widget.recipeInfo['user_user_id'],
                authorBio: widget.authorBio),
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
  const RecipeCreator(
      {super.key,
      required this.authorName,
      required this.profileImage,
      required this.authorId,
      required this.authorBio});

  //final String profileImage = "lib/imgs/cheeseprofile.PNG";
  final String? profileImage;
  final String authorName;
  final int authorId;
  final String? authorBio;

  @override
  State<RecipeCreator> createState() => _RecipeCreatorState();
}

class _RecipeCreatorState extends State<RecipeCreator> {
  //final int followers = 0;
  //final int recipes = 0;

  Future<List<dynamic>> getSavedRecipes(int user_id) async {
    var url = Uri.http('3.93.61.3', '/api/feed/getUserSavedRecipes/$user_id');
    var response = await http.get(url, headers: {
      "Authorization": 'Bearer ${globals.token}',
      "Accept": "application/json"
    });

    final data = jsonDecode(response.body)['recipes'];

    return data;
  }

  @override
  Widget build(BuildContext context) {
    Future<List<dynamic>> getCreatedRecipes(int user_id) async {
      var url = Uri.http('3.93.61.3', '/api/feed/userRecipes/$user_id');
      var response = await http.get(
        url,
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
                  List<dynamic> tempCreated =
                      await getCreatedRecipes(widget.authorId);

                  if (widget.authorId == globals.user['user_id']) {
                    setState(() {
                      globals.createdRecipes = tempCreated;
                    });

                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(),
                      screen: Profile(
                        //profileImage: profileImage,
                        displayName: widget.authorName,
                        username: "", // temporary fix to not break things
                        followers: 0,
                        recipes: 0,
                        bio: widget.authorBio ?? "",
                      ),
                      withNavBar: true,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                  } else {
                    List<dynamic> tempSaved =
                        await getSavedRecipes(widget.authorId);
                    
                    tempCreated = tempCreated.where((recipe) => recipe['is_public'] == 0).toList();

                    PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                      context,
                      settings: const RouteSettings(),
                      screen: OthersProfile(
                        //profileImage: profileImage,
                        displayName: widget.authorName,
                        username: "", // temporary fix to not break things
                        followers: 0,
                        recipes: 0,
                        bio: widget.authorBio ?? "",
                        profilePicture: widget.profileImage ?? "",
                        createdRecipes: tempCreated,
                        savedRecipes: tempSaved,
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
                      )),
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
    return Wrap(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Prep Time
        //const Spacer(),
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
              TextSpan(text: '$prepTime mins | ')
            ],
          ),
        ),
        //const Spacer(),
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
              TextSpan(text: '$cookTime mins | ')
            ],
          ),
        ),
        //const Spacer(),
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
        //const Spacer(),
      ],
    );
  }
}
