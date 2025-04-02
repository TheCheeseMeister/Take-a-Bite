import 'package:flutter/material.dart';

class CreateRecipe extends StatefulWidget {
  const CreateRecipe({super.key});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

// Rough form as base for page (for now)
class _CreateRecipeState extends State<CreateRecipe> {
  final formKey = GlobalKey<FormState>();

  // Controllers to get values from form
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final prepController = TextEditingController();
  final cookController = TextEditingController();
  final servingSizeController = TextEditingController();

  // Image selector somewhere??
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
        child: Form(
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 4),
              child: Text(
                "Create a Recipe",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Text(
              "Enter the Recipe's information below",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Divider(
              indent: 50,
              endIndent: 50,
            ),
            // Title of Recipe
            Padding(
              padding: const EdgeInsets.fromLTRB(0,16,0,16),
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: TextFormField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: "Title *",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return (value != null && value != "")
                          ? null
                          : "A title is required.";
                    }),
              ),
            ),
            // Subtitle/text
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,16),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: TextFormField(
                    controller: subtitleController,
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: "Subtitle *",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return (value != null && value != "")
                          ? null
                          : "A subtitle is required.";
                    }),
              ),
            ),
            // Ingredients (proportions too)
            // Prep Time
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,16),
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child: TextFormField(
                  controller: prepController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Prep Time (mins) *",
                    labelStyle: TextStyle(
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(),
                  ),
                  style: const TextStyle(
                      //fontSize: 16,
                      ),
                  validator: (String? value) {
                    return (value != null && value != "")
                        ? null
                        : "Prep Time must be specified.";
                  }
                ),
              ),
            ),
            // Cook Time
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,16),
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child: TextFormField(
                  controller: cookController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Cook Time (mins) *",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  validator: (String? value) {
                    return (value != null && value != "")
                        ? null
                        : "Cook Time must be specified.";
                  }
                ),
              ),
            ),
            // Serving Size
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,0,16),
              child: FractionallySizedBox(
                widthFactor: 0.4,
                child: TextFormField(
                  controller: servingSizeController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Serving Size *",
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  validator: (String? value) {
                    return (value != null && value != "")
                        ? null
                        : "Serving Size must be specified.";
                  }
                ),
              ),
            ),
            // Instructions
            // Create/Submit Button
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
                            Text("Subtitle: ${subtitleController.text}"),
                            Text("Prep Time: ${prepController.text}"),
                            Text("Cook Time: ${cookController.text}"),
                            Text("Serving Size: ${servingSizeController.text}"),
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
          ]),
        ),
      ),
    );
  }
}
