<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Recipe;
use App\Models\UserSaved;
use Illuminate\Http\Request;
use App\Http\Requests\UserSavedRequest;
use Carbon\Carbon;


class UserSavedController extends Controller
{
    protected $table = 'TAB_user_recipe_save';
    protected $primaryKey = 'user_recipe_save_id';


    public function storeUserSaved(UserSavedRequest $request){
        $request->validated();

	$copy = UserSaved::where('urs_user_id',$request->urs_user_id)
		->where('urs_recipe_id',$request->urs_recipe_id)
		->exists();
	
	// Check if entry has already been saved
	if ($copy) {
	    return response([
	    	'message' => 'This recipe was already saved.',
	    ], 302);
	}

        UserSaved::create([
            'urs_user_id' => $request->urs_user_id,
            'urs_recipe_id' => $request->urs_recipe_id,
	    'urs_date_saved' => Carbon::now(),
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

    public function getUserSavedRecipes($urs_user_id)
    {
	$recipes = UserSaved::where('urs_user_id',$urs_user_id)
		->with('recipe')->get()->pluck('recipe');
	
	return response([
	    'recipes' => $recipes
	], 201);
    }

    public function removeUserSaved(Request $request)
    {
	UserSaved::where('urs_user_id',$request->urs_user_id)->where('urs_recipe_id',$request->urs_recipe_id)->delete();
	
	return response([
	    'message' => 'success'
	], 201);
    }

}
