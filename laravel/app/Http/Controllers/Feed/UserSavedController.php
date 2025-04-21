<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Recipe;
use App\Models\UserSaved;
use Illuminate\Http\Request;
use App\Http\Requests\UserSavedRequest;


class UserSavedController extends Controller
{
    protected $table = 'TAB_user_recipe_save';
    protected $primaryKey = 'user_recipe_save_id';


    public function storeUserSaved(UserSavedRequest $request){
        $request->validated();
        UserSaved::create([
            'urs_user_id' => $request->urs_user_id,
            'urs_recipe_id' => $request->urs_recipe_id,
        ]);

        return response([
            'message' => 'success',
        ],201);
    }


    public function getUserSaved($userSavedID) //get recipes from recipe
    {
        $recipes = UserSaved::where("user_recipe_save_id", "=", $userSavedID)->get();

        return response([
            'user saved' => $recipes
        ], 212);
        
    }

}
