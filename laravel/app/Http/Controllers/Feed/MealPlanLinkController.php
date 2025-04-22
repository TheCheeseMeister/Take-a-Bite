<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Http\Requests\MealPlanLinkRequest;
use App\Models\MealPlanLink;
use Illuminate\Http\Request;

class MealPlanLinkController extends Controller
{
    
    protected $table = 'TAB_mealplan_user_recipe';
    protected $primaryKey = 'mur_id';
    public $timestamps = false;

    public function store(MealPlanLinkRequest $request){
        $request->validated();

        MealPlanLink::create([
            'mur_user_id' => $request->mur_user_id,
            'mur_recipe_id' => $request->mur_recipe_id,
            'mur_mealplan_id' => $request->mur_mealplan_id,
        ]);

        return response([
            'message' => MealPlanLink::get(), //return mealplan id
        ],201);

    }

    public function getMealPlans($mealPlan_id)
    {
        $recipe_name = MealPlanLink::where('mur_id', "=", $mealPlan_id)->get();

        return response([
            'meal plan link' => $recipe_name,
        ],200);
    }
}
