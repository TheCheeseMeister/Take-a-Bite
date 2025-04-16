import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:take_a_bite/globals.dart' as globals;
import 'package:image/image.dart' as img;

class Ingredient {
  final Map<String, dynamic> ingredientInfo;
  final String portion;

  Ingredient({required this.ingredientInfo, required this.portion});
}

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
  final portionController = TextEditingController();
  final instructionsController = TextEditingController();
  
  bool isVegan = false;
  bool isGlutenFree = false;

  File ? selectedImage;

  bool testLoading = false;
  String? testImageUrl;

  //Map<String, dynamic> tempIngredient = {};
  Map<String, dynamic> tempIngredient = {};
  //List<Map<Map<String, dynamic>, int>> ingredients = [];
  List<Ingredient> ingredients = [];

  // Image selector somewhere??
  @override
  Widget build(BuildContext context) {
    Future<http.Response> storeRecipe(String recipe_name, String cook_time, String prep_time, String recipe_description, String recipe_category, String recipe_servings, String recipe_yield, String recipe_directions, int user_user_id) async {
      // Store Recipe
      var url = Uri.http('3.93.61.3', '/api/feed/store');
      /*var response = await http.post(
        url, headers: {"Authorization": 'Bearer ${globals.token}', "Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          'recipe_name': recipe_name,
          'cook_time': cook_time,
          'prep_time': prep_time,
          'total_time': "NA",
          'recipe_description': recipe_description,
          'recipe_category': "NA",
          'recipe_servings': recipe_servings,
          'recipe_yield': "NA",
          'recipe_directions': recipe_directions})
          //'user_user_id': user_user_id}),
      );*/

      var request = http.MultipartRequest('POST', url);
      request.headers.addAll({
        "Authorization": 'Bearer ${globals.token}',
        //"Content-Type": "application/json",
        "Accept": "application/json"
      });

      request.fields['recipe_name'] = recipe_name;
      request.fields['cook_time'] = cook_time;
      request.fields['prep_time'] = prep_time;
      request.fields['total_time'] = "NA";
      request.fields['recipe_description'] = recipe_description;
      request.fields['recipe_category'] = "NA";
      request.fields['recipe_servings'] = recipe_servings;
      request.fields['recipe_yield'] = "NA";
      request.fields['recipe_directions'] = recipe_directions;

      // Resize file
      if (selectedImage != null) {
        final bytes = await selectedImage!.readAsBytes();
        img.Image? originalImage = img.decodeImage(bytes);

        img.Image resized = img.copyResize(originalImage!, width: 800);
        final resizedBytes = img.encodeJpg(resized, quality: 80);
        final resizedImage = File(selectedImage!.path)..writeAsBytesSync(resizedBytes);

        var file = await http.MultipartFile.fromPath('image', resizedImage.path);
        request.files.add(file);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print(response.statusCode);

      return response;
    }

    Future<http.Response> storeRecipeTag(int tags_id, int recipe_id) async {
      var url = Uri.http('3.93.61.3', '/api/feed/tagRecipe/store');
      var response = await http.post(
        url, headers: {"Authorization": 'Bearer ${globals.token}', "Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          'tags_id': tags_id,
          'recipe_id': recipe_id}) // ingredients_id should be recipe_id
      );
      return response;
    }

    Future<http.Response> storeRecipeIngredient(int ri_recipe_id, int ri_ingredient_id, ri_ingredient_measurement) async {
      var url = Uri.http('3.93.61.3', 'api/feed/recipeIngredient/store');
      var response = await http.post(
        url, headers: {"Authorization": 'Bearer ${globals.token}', "Content-Type": "application/json", "Accept": "application/json"},
        body: jsonEncode({
          'recipe_id': ri_recipe_id,
          'ingredient_id': ri_ingredient_id,
          'ingredient_measurement': ri_ingredient_measurement})
      );
      return response;
    }
    
    Future imageFromGallery() async {
      final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (returnedImage == null) return;
      setState(() {selectedImage = File(returnedImage!.path);});
    }

    Future<void> testGetImage(int recipe_id) async {
      setState(() {testLoading = true;});

      var url = Uri.http('3.93.61.3', 'api/feed/store/$recipe_id');
      var response = await http.get(
        url, headers: {"Authorization": 'Bearer ${globals.token}', "Content-Type": "application/json", "Accept": "application/json"},
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['recipe_name'][0];
        final retreivedUrl = data['recipe_image'];
        print(data);
        print(retreivedUrl);

        setState(() {testImageUrl = retreivedUrl;});
      }

      setState(() {testLoading = false;});
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
          child: Form(
            key: formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
              // Image Picker
              selectedImage != null
              ? Image.file(selectedImage!)
              : Text("No Image selected yet"),
              TextButton(
                onPressed: () {
                  imageFromGallery();
                },
                child: Text("Select an image"),
              ),
              // Title of Recipe
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                      controller: subtitleController,
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
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
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: Text(
                        "No Ingredients Selected",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: ingredients.map((ingredient) {
                        var tempInfo = ingredient.ingredientInfo;
                        var tempPortion = ingredient.portion;
                        return FractionallySizedBox(
                          widthFactor: 0.8,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tempInfo["ingredient_name"]),
                                    //Text("Temp portion display"),
                                    Text(tempPortion),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
              // Ingredient input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: DropdownSearch<String>(
                        items: (filter, s) => globals.ingredientsList
                            .map<String>(
                                (ingredient) => ingredient['ingredient_name'])
                            .toList(),
                        compareFn: (i, s) => i == s,
                        onChanged: (String? item) {
                          // TODO: add httprequest to search for recipes with selected items
                          if (item != null) {
                            var ingredientInfo = globals.ingredientsList
                                .firstWhere((ingredient) =>
                                    ingredient['ingredient_name'] == item);
                            setState(() {
                              tempIngredient = ingredientInfo;
                            });
                            print(tempIngredient);
                          }
                        },
                        popupProps: PopupProps.menu(
                          menuProps: const MenuProps(
                              backgroundColor:
                                  Color.fromARGB(255, 255, 255, 255)),
                          showSearchBox: true,
                          constraints:
                              const BoxConstraints(maxWidth: 500, maxHeight: 200),
                          itemBuilder: (context, item, isDisabled, isSelected) {
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
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
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                        controller: portionController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          labelText: "Portion *",
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          return (value == null || value.isEmpty)
                              ? "Required"
                              : null;
                        }),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: TextButton(
                      onPressed: () {
                        if (tempIngredient.isNotEmpty) {
                          Ingredient temp = Ingredient(ingredientInfo: tempIngredient, portion: portionController.text);
                          setState(() {
                            ingredients.add(temp);
                          });
                        }
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
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          ingredients = [];
                        });
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
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                      }),
                ),
              ),
              // Cook Time
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                      }),
                ),
              ),
              // Serving Size
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
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
                      }),
                ),
              ),
              // Instructions
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: TextFormField(
                      controller: instructionsController,
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: "Instructions *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (String? value) {
                        return (value == null || value.isEmpty)
                            ? "Required"
                            : null;
                      }),
                ),
              ),
              // Dietary Tags (Vegan, Gluten-Free for now) (24 and 154 respectively in tags table, hard coded for now)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("Vegan"),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.black,
                      value: isVegan,
                      onChanged: (bool? value) {
                        setState(() {isVegan = value!;});
                      },
                      fillColor: WidgetStateColor.resolveWith(
                        (Set<WidgetState> states) {
                          const Set<WidgetState> interactiveStates = <WidgetState>{
                            WidgetState.pressed,
                            WidgetState.hovered,
                            WidgetState.focused,
                            WidgetState.selected,
                          };
                    
                          if (states.any(interactiveStates.contains)) {
                            return Colors.blue;
                          }
                          return const Color.fromARGB(255, 255, 255, 255);
                      }),
                    ),
                  ),
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text("Gluten Free"),
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.black,
                      value: isGlutenFree,
                      onChanged: (bool? value) {
                        setState(() {isGlutenFree = value!;});
                      },
                      fillColor: WidgetStateColor.resolveWith(
                        (Set<WidgetState> states) {
                          const Set<WidgetState> interactiveStates = <WidgetState>{
                            WidgetState.pressed,
                            WidgetState.hovered,
                            WidgetState.focused,
                            WidgetState.selected,
                          };
                    
                          if (states.any(interactiveStates.contains)) {
                            return Colors.blue;
                          }
                          return const Color.fromARGB(255, 255, 255, 255);
                      }),
                    ),
                  ),
                ],
              ),
              // Create/Submit Button
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    // STORE RECIPE //
                    //------------------------------------------//
                    // recipe_name = titleController.text
                    // cook_time = cookController.text
                    // prep_time = prepController.text
                    // recipe_description = subtitleController.text
                    // recipe_category = "N/A"
                    // recipe_servings = servingSizeController.text
                    // recipe_yield = "N/A"
                    // recipe_directions = instructionsController.text
                    // user_user_id = globals.user["user_id"]
                    //------------------------------------------//
                    http.Response storeRecipeResponse = await storeRecipe(
                      titleController.text,
                      cookController.text,
                      prepController.text,
                      subtitleController.text,
                      "N/A",
                      servingSizeController.text,
                      "N/A",
                      instructionsController.text,
                      globals.user["user_id"]
                    );

                    // STORE TAG RECIPE LINK //
                    //------------------------------------------//
                    // * Note: request for each tag
                    // tags_id = 24 or 154, hardcoded for now
                    // recipe_id = response["recipe_id"] from storing recipe
                    //------------------------------------------//
                    print(jsonDecode(storeRecipeResponse.body));
                    int recipe_id = jsonDecode(storeRecipeResponse.body)['message']['recipe_id'];

                    print(recipe_id);
                    print(recipe_id.runtimeType);
                    
                    http.Response? veganResponse;
                    http.Response? glutenResponse;

                    if (isVegan) {
                      veganResponse = await storeRecipeTag(24, recipe_id);
                    }

                    if (isGlutenFree) {
                      glutenResponse = await storeRecipeTag(154, recipe_id);
                    }

                    if (glutenResponse?.statusCode == 422) {
                      final data = jsonDecode(glutenResponse!.body);
                      print('Validation errors: ${data['errors']}');
                    }

                    List<http.Response> ingredientResponses = [];

                    // STORE RECIPE INGREDIENTS //
                    //------------------------------------------//
                    // * Note: request for each ingredient
                    // ri_recipe_id = response["recipe_id"] from storing recipe
                    // ri_ingredient_id = ingredient.ingredientInfo["ingredient_id"]
                    // ri_ingredient_measurement = ingredient.portion
                    //------------------------------------------//
                    for (Ingredient ingredient in ingredients) {
                      int ingredient_id = ingredient.ingredientInfo["ingredient_id"];
                      http.Response response = await storeRecipeIngredient(recipe_id, ingredient_id, ingredient.portion);
                      
                      if (response.statusCode == 422) {
                        final data = jsonDecode(response.body);
                        print('Validation errors: ${data['errors']}');
                      }
                      
                      ingredientResponses.add(response);
                    }

                    // Success Dialog
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Recipe successfully created!"),
                              const SizedBox(height: 15),
                              const Text("Status Codes:"),
                              Text("Store Recipe - Status: ${storeRecipeResponse.statusCode}"),
                              isVegan
                              ? Text("Recipe Vegan - Status: ${veganResponse?.statusCode}")
                              : Text("Recipe Vegan - None"),
                              isGlutenFree
                              ? Text("Recipe Gluten - Status: ${glutenResponse?.statusCode}")
                              : Text("Recipe Gluten - None"),
                              ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: ingredientResponses.map((response) {
                                  return Text("Ingredient Response - ${response.statusCode}");
                                }).toList(),
                              ),
                              /*const Text("Current Values:"),
                              Text("Title: ${titleController.text}"),
                              Text("Subtitle: ${subtitleController.text}"),
                              Text("Prep Time: ${prepController.text}"),
                              Text("Cook Time: ${cookController.text}"),
                              Text("Serving Size: ${servingSizeController.text}"),*/
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
              if (testLoading) CircularProgressIndicator(),
              if (testImageUrl != null) Image.network(testImageUrl!)
              else if (!testLoading) Text("No image loaded"),
              TextButton(
                onPressed: () {
                  testGetImage(1033);
                },
                child: Text("Press me to load test url!"),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
