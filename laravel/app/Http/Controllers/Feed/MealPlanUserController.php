<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Http\Requests\MealPlanUserRequest;
use App\Models\MealPlanUser;
use Illuminate\Http\Request;


class MealPlanUserController extends Controller
{

    protected $table = 'TAB_meal_plan_user';
    protected $primaryKey = 'mp_user_id';


    public function store(MealPlanUserRequest $request){
        $request->validated();

        auth()->user()->feeds()->create([
            'mp_id' => $request->mp_id,
            'user_id' => $request->user_id
        ]);

        return response([
            'message' => auth()->user()->feeds()->latest()->first(), //return recipe id
        ],201);

    }

    public function getMealPlans($mealPlanUser_id)
    {
        $recipe_name = MealPlanUser::with('user')->where('mp_user_id', "=", $mealPlanUser_id)->latest()->get();

        return response([
            'meal plan users' => $recipe_name,
        ],200);
    }

}
