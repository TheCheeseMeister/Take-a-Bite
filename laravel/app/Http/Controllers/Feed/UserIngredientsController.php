<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Http\Requests\UserIngredientsRequest;
use App\Models\UserIngredients;
use Illuminate\Http\Request;


class UserIngredientsController extends Controller
{
    protected $table = 'TAB_user_ingredients';
    protected $primaryKey = 'user_ingredient_id';

    public $timestamps = false;

    public function store(UserIngredientsRequest $request){
        $request->validated();

        UserIngredients::create([
            'ui_ingredient_id' => $request->ui_ingredient_id,
            'ui_user_id' => $request->ui_user_id,
            'ui_expiration_date' => $request->ui_expiration_date,
            'ui_ingredient_amount' => $request->ui_ingredient_amount,

        ]);

        return response([
            'message' => UserIngredients::first(), //return mealplan id
        ],201);

    }

    public function getUserIngredients($userIngredientID)
    {
        $recipe_name = UserIngredients::where('user_ingredient_id', "=", $userIngredientID)->get();

        return response([
            'user ingredients' => $recipe_name,
        ],200);
    }
}
