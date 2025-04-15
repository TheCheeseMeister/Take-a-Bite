<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Ingredients;
use App\Models\RecipeIngredients;
use App\Models\Recipe;
use App\Http\Requests\RecipeIngredientRequest;

class RecipeIngredientsLinkController extends Controller
{

    protected $table = 'TAB_recipes_ingredients';
    protected $primaryKey = 'recipes_ingredients_id';



    public function storeRecipeIngredients(RecipeIngredientRequest $request){
        $request->validated();

        RecipeIngredients::create([
            'ri_recipe_id' => $request->recipe_id,
            'ri_ingredient_id' => $request->ingredient_id,
            'ri_ingredient_measurement' => $request->ingredient_measurement
        ]);

        return response([
            'message' => 'success',
        ],201);
    }


    public function getRecipeIngredient($recipe_id) //get ingredients from recipe
    {
        $ingredients = RecipeIngredients::get();

        return response([
            'ingredients' => $ingredients
        ], 212);
        
    }

    //add get that gets all ingredients from recipe id

}
