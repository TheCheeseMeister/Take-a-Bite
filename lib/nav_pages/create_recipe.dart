import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:take_a_bite/globals.dart' as globals;

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

  Map<String, dynamic> tempIngredient = {};
  List<Map<String, dynamic>> ingredients = [];

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
                widthFactor: 0.8,
                child: TextFormField(
                    controller: titleController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: "Title *",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return (value == null || value.isEmpty)
                          ? "Required"
                          : value.length < 2
                          ? "Recipe title should min 2 characters."
                          : null;
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
                      labelText: "Subtitle",
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return null;
                    }),
              ),
            ),
            // Ingredients display (proportions too)
            ingredients.isEmpty
            ? Text("No Ingredients")
            : ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: ingredients.map((ingredient) {
                return FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,0,8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(ingredient["ingredient_name"]),
                            Text("Temp portion display"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            // Ingredient input
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: DropdownSearch<String>(
                  items: (filter, s) => globals.ingredientsList.map<String>((ingredient) => ingredient['ingredient_name']).toList(),
                  compareFn: (i, s) => i == s,
                  onChanged: (String? item) {
                    // TODO: add httprequest to search for recipes with selected items
                    if (item != null) {
                      var ingredientInfo = globals.ingredientsList.firstWhere((ingredient) => ingredient['ingredient_name'] == item);
                      setState(() {tempIngredient = ingredientInfo;});
                      print(tempIngredient);
                    }
                  },
                  popupProps: PopupProps.menu(
                    menuProps: const MenuProps(backgroundColor: Color.fromARGB(255, 255, 255, 255)),
                    showSearchBox: true,
                    constraints: const BoxConstraints(maxWidth: 500, maxHeight: 200),
                    itemBuilder: (context, item, isDisabled, isSelected) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.toString()),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,8,8,8),
                  child: TextButton(
                    onPressed: () {
                      if (tempIngredient.isNotEmpty) setState((){ingredients.add(tempIngredient);});
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 129, 214, 131),
                    ),
                    child: const Text(
                      "Add Ingredient",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,8,0,8),
                  child: TextButton(
                    onPressed: () {
                      setState((){ingredients = [];});
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 255, 106, 106),
                    ),
                    child: const Text(
                      "Clear Ingredients",
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                    return (value == null || value.isEmpty)
                        ? "Required."
                        : value.length < 2
                        ? "why?"
                        : null;
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
                    return (value == null || value.isEmpty)
                        ? "Required."
                        : value.length < 2
                        ? "why?"
                        : null;
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
                    return (value == null || value.isEmpty)
                        ? "Required."
                        : value.length < 2
                        ? "why?"
                        : null;
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
