library globals;

import 'package:flutter/material.dart';

// Stores user info when logging in
Map<String, dynamic> user = {};

// Value notifier for bio (because its weird)
ValueNotifier<String> userBio = ValueNotifier<String>("");

// Recipes user created
List<dynamic> createdRecipes = [];

// Recipes user saved
List<dynamic> savedRecipes = [];

// Meal Plans for user
List<dynamic>? plans = [];

// Meal Plans sorted by Date (for refreshing from navbar)
Map<String, List<Map<String, dynamic>>> datedPlans = {};

// To update plans display
final plansChanged = ValueNotifier<int>(0);

// Token for HttpRequests
String token = "";

// Ingredients list
List<dynamic> ingredientsList = List.empty();

// Tags list
List<dynamic> tagsList = List.empty();