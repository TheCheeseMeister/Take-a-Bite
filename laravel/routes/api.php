<?php

use App\Http\Controllers\Auth\AuthenticationController;
use App\Http\Controllers\Feed\RecipeController;
use App\Http\Controllers\Feed\RecipeIngredientsLinkController;
use App\Http\Controllers\Feed\TagController;
use App\Http\Controllers\Feed\TagIngredientController;
use App\Http\Controllers\Feed\TagRecipeController;
use App\Http\Controllers\Feed\UserController;
use App\Http\Controllers\Feed\UserIngredientsController;
use App\Http\Controllers\Feed\UserSavedController;
use App\Http\Controllers\Feed\MealPlanController;
use App\Http\Controllers\Feed\MealPlanLinkController;

use App\Models\MealPlan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;





Route::get('/feeds', [RecipeController::class,'index'])->middleware('auth:sanctum');

Route::post('/feed/store', [RecipeController::class,'store'])->middleware('auth:sanctum');

Route::get('/feed/store/{feed_id}', [RecipeController::class,'getRecipe'])->middleware('auth:sanctum');

Route::get('/feed/recipe/', [RecipeController::class,'getRecipes'])->middleware('auth:sanctum');

Route::post('/feed/like/{feed_id}', [RecipeController::class,'likePost'])->middleware('auth:sanctum');

Route::post('/feed/comment/{feed_id}', [RecipeController::class,'comment'])->middleware('auth:sanctum');

Route::get('/feed/comments/{feed_id}', [RecipeController::class,'getComments'])->middleware('auth:sanctum');

Route::get('/feed/ingredients/', [RecipeController::class,'getIngredients'])->middleware('auth:sanctum');

Route::get('/feed/ingredients/{ingredient_id}', [RecipeController::class,'getIngredient'])->middleware('auth:sanctum');

Route::get('/feed/recipeIngredient/{recipe_id}', [RecipeIngredientsLinkController::class,'getRecipeIngredient'])->middleware('auth:sanctum');

Route::post('/feed/recipeIngredient/store', [RecipeIngredientsLinkController::class,'storeRecipeIngredients'])->middleware('auth:sanctum');

Route::get('/feed/tag/{tags_id}', [TagController::class,'getTag'])->middleware('auth:sanctum');

Route::get('/feed/tag', [TagController::class,'getTags'])->middleware('auth:sanctum');

Route::post('/feed/tagIngredient/store', [TagIngredientController::class,'storeTagIngredients'])->middleware('auth:sanctum');

Route::get('/feed/tagIngredient/{tagIngredientID}', [TagIngredientController::class,'getTagIngredient'])->middleware('auth:sanctum');

Route::post('/feed/tagRecipe/store', [TagRecipeController::class,'storeTagRecipe'])->middleware('auth:sanctum');

Route::get('/feed/tagRecipe/{tagRecipeID}', [TagRecipeController::class,'getTagRecipe'])->middleware('auth:sanctum');

Route::get('/feed/userRecipes/{user_id}', [RecipeController::class,'getUserRecipes'])->middleware('auth:sanctum');

Route::get('/feed/users', [UserController::class,'getUsers'])->middleware('auth:sanctum');

Route::post('/feed/changeProfilePicture', [UserController::class,'storeProfilePicture'])->middleware('auth:sanctum');

Route::post('/feed/changeProfileBio', [UserController::class,'storeProfileBio'])->middleware('auth:sanctum');

Route::get('/feed/getUser/{user_id}', [UserController::class,'getUser'])->middleware('auth:sanctum');

Route::get('/feed/getRecipesAndInfo', [RecipeController::class,'getRecipesAndInfo'])->middleware('auth:sanctum');

Route::post('/feed/userSaved', [UserSavedController::class,'storeUserSaved'])->middleware('auth:sanctum');

Route::get('/feed/userSaved/{userSavedID}', [UserSavedController::class,'getUserSaved'])->middleware('auth:sanctum');

Route::get('/feed/getUserSavedRecipes/{urs_user_id}', [UserSavedController::class, 'getUserSavedRecipes'])->middleware('auth:sanctum');

Route::post('/feed/removeUserSaved', [UserSavedController::class, 'removeUserSaved'])->middleware('auth:sanctum');

Route::post('/feed/mealPlan/store', [MealPlanController::class, 'store'])->middleware('auth:sanctum');

Route::get('/feed/mealPlan/{mealPlan_id}', [MealPlanController::class, 'getMealPlans'])->middleware('auth:sanctum');


Route::post('/feed/mealPlanLink/store', [MealPlanLinkController::class, 'store'])->middleware('auth:sanctum');

Route::get('/feed/mealPlanLink/{mealPlanLink_id}', [MealPlanLinkController::class, 'getMealPlans'])->middleware('auth:sanctum');

Route::post('/feed/userIngredients/store', [UserIngredientsController::class, 'store'])->middleware('auth:sanctum');

Route::get('/feed/userIngredients/{userIngredientsID}', [UserIngredientsController::class, 'getUserIngredients'])->middleware('auth:sanctum');






Route::get('/test', function(){
    return response([
        'message' => 'Api is working'
    ], 200);
});


Route::post('/register', [AuthenticationController::class, 'register']);

Route::post('/login', [AuthenticationController::class, 'login']);


//if not working, clear cache and config, then optimize (php artisan commands)

