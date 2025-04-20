<?php

namespace App\Http\Controllers\Feed;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use App\Http\Requests\TagRecipeRequest;
use App\Models\TagRecipe;


class TagRecipeController extends Controller
{
    protected $table = 'TAB_tags_ingredients';
    protected $primaryKey = 'tags_ingredients_id';


    public function storeTagRecipe(TagRecipeRequest $request){
        $request->validated();
        TagRecipe::create([
            'tags_id' => $request->tags_id,
            'recipe_id' => $request->recipe_id,
        ]);

        return response([
            'message' => 'success',
        ],201);
    }


    public function getTagRecipe($tagRecipeID) //get recipes from recipe
    {
        $recipes = TagRecipe::where("recipe_id", "=", $tagRecipeID)->get();

        return response([
            'ingredients' => $recipes
        ], 212);
        
    }

    //add get that gets all tags from recipe id

    
}
