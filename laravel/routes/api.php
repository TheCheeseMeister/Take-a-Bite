<?php

use App\Http\Controllers\Auth\AuthenticationController;
use App\Http\Controllers\Feed\RecipeController;
use App\Http\Controllers\Feed\RecipeIngredientsLinkController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;




Route::get('/feeds', [RecipeController::class,'index'])->middleware('auth:sanctum');

Route::post('/feed/store', [RecipeController::class,'store'])->middleware('auth:sanctum');

Route::get('/feed/store/{feed_id}', [RecipeController::class,'getRecipe'])->middleware('auth:sanctum');

Route::post('/feed/like/{feed_id}', [RecipeController::class,'likePost'])->middleware('auth:sanctum');

Route::post('/feed/comment/{feed_id}', [RecipeController::class,'comment'])->middleware('auth:sanctum');

Route::get('/feed/comments/{feed_id}', [RecipeController::class,'getComments'])->middleware('auth:sanctum');

Route::get('/feed/ingredients/', [RecipeController::class,'getIngredients'])->middleware('auth:sanctum');

Route::get('/feed/ingredients/{ingredient_id}', [RecipeController::class,'getIngredient'])->middleware('auth:sanctum');

Route::get('/feed/recipeIngredient/{recipe_id}', [RecipeIngredientsLinkController::class,'getRecipeIngredient'])->middleware('auth:sanctum');

Route::post('/feed/recipeIngredient/store', [RecipeIngredientsLinkController::class,'storeRecipeIngredients'])->middleware('auth:sanctum');
//Route::post('/feed/recipeIngredient/store', [RecipeController::class,'store'])->middleware('auth:sanctum');


Route::get('/test', function(){
    return response([
        'message' => 'Api is working'
    ], 200);
});


Route::post('/register', [AuthenticationController::class, 'register']);

Route::post('/login', [AuthenticationController::class, 'login']);


//if not working, clear cache and config, then optimize (php artisan commands)

