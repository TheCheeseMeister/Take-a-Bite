<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Http\Requests\MealPlanRecipeRequest;
use App\Models\MealPlanRecipe;
use Illuminate\Http\Request;

class MealPlanRecipeController extends Controller
{
    
    protected $table = 'TAB_meal_plan_user';
    protected $primaryKey = 'mp_user_id';


    public function store(MealPlanRecipeRequest $request){
        $request->validated();

        auth()->user()->feeds()->create([
            'mp_id' => $request->mp_id,
            'recipe_id' => $request->recipe_id
        ]);

        return response([
            'message' => auth()->user()->feeds()->latest()->first(), //return recipe id
        ],201);

    }

    public function getMealPlans($mealPlanUser_id)
    {
        $recipe_name = MealPlanRecipe::with('user')->where('mp_recipe_id', "=", $mealPlanUser_id)->latest()->get();

        return response([
            'meal plan recipes' => $recipe_name,
        ],200);
    }

}
