import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:take_a_bite/nav_pages/profile.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({
    super.key,
    required this.image,
    required this.title,
    required this.ingredients,
    required this.prepTime,
    required this.cookTime,
    required this.servingSize,
    required this.instructions,
    required this.index,
  });

  // Info passed from Recipe Card
  final Image image;
  final String title;
  final List<String> ingredients;
  final int prepTime;
  final int cookTime;
  final String servingSize;
  final String instructions; // Description of recipe
  final int index; // For hero

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.5;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'recipe-$index',
              child: image,
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
                child: const Text(
                  "Learn the ins and outs of making a Pizza in 10 minutes from the comfort of your own home.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                ),
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
                    children: ingredients.map((str) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: Text(
                          str,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }).toList(),
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
            const RecipeCreator(),
            // Comments (can go to poster's profile from comment)
            const Padding(
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
            ),
          ],
        ),
      ),
    );
  }
}

// Displays Recipe Creator and info, option to go to profile
class RecipeCreator extends StatelessWidget {
  const RecipeCreator({super.key});

  final String profileImage = "lib/imgs/cheeseprofile.PNG";
  final String displayName = "CheeseHater";
  final String username = "@NoCheesers";
  final int followers = 0;
  final int recipes = 0;
  final String bio = "Fake Cooker.\nSeeking cheese destruction all over.\n#CheeseHaters25";

  @override
  Widget build(BuildContext context) {
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
              onTap: () => PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                context,
                settings: const RouteSettings(),
                screen: Profile(
                  profileImage: profileImage,
                  displayName: displayName,
                  username: username,
                  followers: followers,
                  recipes: recipes,
                  bio: bio,
                ),
                withNavBar: true,
                pageTransitionAnimation: PageTransitionAnimation.fade,
              ),
              child: const Hero(
                tag: 'profile-image',
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/imgs/cheeseprofile.PNG'),
                ),
              ),
            ),
          ),
        ),
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "Written by",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 12,
            ),
          ),
          Text(
            "CheeseLover",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          Text(
            "@CheeseBros",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
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

  final int prepTime;
  final int cookTime;
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
