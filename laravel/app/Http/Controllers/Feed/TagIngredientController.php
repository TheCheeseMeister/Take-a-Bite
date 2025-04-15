<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\TagIngredientRequest;
use App\Models\TagIngredient;


class TagIngredientController extends Controller
{

    protected $table = 'TAB_tags_ingredients';
    protected $primaryKey = 'tags_ingredients_id';


    public function storeTagIngredients(TagIngredientRequest $request){
        $request->validated();

        TagIngredient::create([
            'tags_id' => $request->tags_id,
            'ingredients_id' => $request->ingredients_id,
        ]);

        return response([
            'message' => 'success',
        ],201);
    }


    public function getTagIngredient($tagIngredientID) //get ingredients from recipe
    {
        $ingredients = TagIngredient::where("tags_ingredients_id", "=", $tagIngredientID)->get();

        return response([
            'ingredients' => $ingredients
        ], 212);
        
    }

    

}
