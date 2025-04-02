import 'package:flutter/material.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

// Rough form as base for page (for now)
class _CreateRecipeState extends State<CreateRecipe> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.9,
      heightFactor: 0.9,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            // Title of Recipe
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title *",
              ),
              validator: (String? value) {
                return (value != null && value != "") ? null : "A title is required.";
              }
            ),
            // Subtitle/text
            // Ingredients (proportions too)
            // Prep Time / Cook Time / Serving Size
            // Instructions
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Recipe successfuly created (soon)"),
                            const SizedBox(height: 15),
                            const Text("Current Values:"),
                            Text("Title: ${titleController.text}"),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
              child: const Text("Submit"),
            ),
          ]
        ),
      ),
    );
  }
}