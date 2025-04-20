library globals;

import 'package:flutter/material.dart';

// Stores user info when logging in
Map<String, dynamic> user = {};

// Value notifier for bio (because its weird)
ValueNotifier<String> userBio = ValueNotifier<String>("");

// Recipes user created
List<dynamic> createdRecipes = [];

// Token for HttpRequests
String token = "";

// Ingredients list
List<dynamic> ingredientsList = List.empty();

// Tags list
List<dynamic> tagsList = List.empty();