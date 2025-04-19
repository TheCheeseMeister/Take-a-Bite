library globals;

// Stores user info when logging in
Map<String, dynamic> user = {};

// Recipes user created
List<dynamic> createdRecipes = [];

// Token for HttpRequests
String token = "";

// Ingredients list
List<dynamic> ingredientsList = List.empty();

// Tags list
List<dynamic> tagsList = List.empty();