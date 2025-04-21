<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Http\Requests\MealPlanRequest;
use App\Models\Recipe;
use Illuminate\Http\Request;

class MealPlanController extends Controller
{
    

    public function store(MealPlanRequest $request){
        $request->validated();

        auth()->user()->feeds()->create([
            'date_to_make' => $request->date_to_make,
            'time_to_make' => $request->time_to_make
        ]);

        return response([
            'message' => auth()->user()->feeds()->latest()->first(), //return recipe id
        ],201);

    }

    public function getMealPlans($mealPlan_id)
    {
        $recipe_name = Recipe::with('user')->where('meal_plan_id', "=", $mealPlan_id)->latest()->get();

        return response([
            'meal plans' => $recipe_name,
        ],200);
    }

}
