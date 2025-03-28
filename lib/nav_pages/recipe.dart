import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({
    super.key,
    required this.image,
    required this.title,
    required this.prepTime,
    required this.cookTime,
    required this.servingSize,
    required this.instructions,
    required this.index,
  });

  // Info passed from Recipe Card
  final Image image;
  final String title;
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
            // Prep Time, Cook Time, Serving Size
            RecipeStats(prepTime: prepTime, cookTime: cookTime, servingSize: servingSize),
            // Description / instructions
            const Padding(
              padding: EdgeInsets.fromLTRB(0,24,0,0),
              child: Divider(
                height: 2,
                indent: 40,
                endIndent: 40,
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,24,0,0),
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
              padding: EdgeInsets.fromLTRB(0,24,0,24),
              child: Divider(
                height: 2,
                indent: 20,
                endIndent: 20,
                thickness: 1,
                color: Color.fromARGB(255, 168, 168, 168),
              ),
            ),
            // Poster's profile (i.e. Made by CheeseMaster) / Likes? Or maybe Likes higher
            Text("Insert creator profile here"),
            // Comments (can go to poster's profile from comment)
          ],
        ),
      ),
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