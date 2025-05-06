<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Models\Ingredients;
use Illuminate\Http\Request;
use App\Http\Requests\PostRequest;
use App\Models\Recipe;
use App\Models\Like;
use App\Models\Comment;

class RecipeController extends Controller
{

    protected $table = 'TAB_recipes';
    protected $primaryKey = 'recipe_id';

    public function index(Request $request)
    {
        $feeds = Recipe::with('user')->latest()->get();
        return response([
            'recipe' => $feeds

        ], 200);
    }


    public function store(PostRequest $request){
        $request->validated();
	$imagePath = NULL;

	if ($request->hasFile('image') && $request->file('image')->isValid()) {
	    $path = $request->file('image')->store('images', 'public');
	    $imagePath = url('storage/' . $path);
	}

        auth()->user()->feeds()->create([
            'recipe_name' => $request->recipe_name,
            'cook_time' => $request->cook_time,
            'prep_time' => $request->prep_time,
            'recipe_description' => $request->recipe_description,
            'recipe_category' => $request->recipe_category,
            'recipe_servings' => $request->recipe_servings,
            'recipe_yield' => $request->recipe_yield,
            'recipe_directions' => $request->recipe_directions,
            'user_user_id' => auth()->id(),
	    'recipe_image' => $imagePath,
	    'is_public' => $request->is_public,
        ]);

        return response([
            'message' => auth()->user()->feeds()->latest()->first(), //return recipe id
        ],201);

    }

    public function getRecipe($feed_id)
    {
        $recipe_name = Recipe::with('user')->where('recipe_id', "=", $feed_id)->latest()->get();

        return response([
            'recipe_name' => $recipe_name,
        ],200);
    }

    public function getRecipes()
    {
        $recipe_name = Recipe::get();

        return response([
            'recipe_name' => $recipe_name,
        ],200);
    }


    public function getUserRecipes($user_id){
        $user_recipes = Recipe::where('user_user_id','=', $user_id)->get();

        return response([
            'user_recipes' => $user_recipes,
        ],200);
    }

    public function getRecipesAndInfo()
    {
	$recipes = Recipe::with([
	    'ingredients.ingredient',
	    'tags.tag'
	])->get();

	$formatted = $recipes->map(function ($recipe) {
	    return [
	    	'recipe_id' => $recipe->recipe_id,
		'recipe_name' => $recipe->recipe_name,
		'cook_time' => $recipe->cook_time,
		'prep_time' => $recipe->prep_time,
		'recipe_description' => $recipe->recipe_description,
		'recipe_category' => $recipe->recipe_category,
		'recipe_servings' => $recipe->recipe_servings,
		'recipe_yield' => $recipe->recipe_yield,
		'recipe_directions' => $recipe->recipe_directions,
		'user_user_id' => $recipe->user_user_id,
		'created_at' => $recipe->created_at,
		'updated_at' => $recipe->updated_at,
		'recipe_image' => $recipe->recipe_image,
		'is_public' => $recipe->is_public,
		'ingredients' => $recipe->ingredients->map(function ($ri) {
		    return [
			'ingredient_id' => $ri->ingredient->ingredient_id ?? 'Unknown',
		    	'ingredient_name' => $ri->ingredient->ingredient_name ?? 'Unknown',
			'portion' => $ri->ri_ingredient_measurement,
		    ];
		}),
		'tags' => $recipe->tags->map(function ($tr) {
		    return [
			'tag_id' => $tr->tag->tags_id,
		    	'tag_name' => $tr->tag->tag_name,
		    ];
		}),
		//'tags' => $recipe->tags->pluck('tags_name'),
	    ];
	});

	return response([
                'user_recipes' => $formatted,
        ],200);
	//return response()->json($formatted, 200);
    }
    
/*
    public function likePost($feed_id)
    {
        $feed = Recipe::where('id', '=', $feed_id)->first();

        
        if(!$feed){
            return response([
                'message'=> '404 not found'
                ],500);
        }
        
        //unlike post

        $unlike_post = Like::where('user_id', auth()->id())->where('feed_id', $feed_id)->delete();
        if($unlike_post){
            return response([
                'message'=> 'Unliked'
                ],200);
            }
        

        $like_post = Like::create([
            'user_id' => auth()->id(),
            'feed_id' => $feed_id]);

        if($like_post){
            return response([
                'message'=> 'Liked'
                ],200);
            }
        
        
        }
        */
        
    public function comment(Request $request, $feed_id)
    {

        $request->validate([
            'body' => 'required'
        ]);

        $comment = Comment::create([
            'user_id'=> auth()->id(),
            'feed_id' => $feed_id,
            'body' => $request->body
        ]);

        return response([

            'message'=> 'success'
            ],201);

    }

    public function getComments($feed_id)
    {
       # $comments = Comment::whereFeedID($feed_id)->latest()->get();
        $comments = Comment::with('feed')->with('user')->where('id', "=", $feed_id)->latest()->get();

        return response([
            'comments' => $comments
        ]);
    }
    
    public function getIngredients() //get all ingredients
    {

       $ingredients = Ingredients::get();

        return response([
            'ingredients' => $ingredients
        ], 212);
    }
    
    public function getIngredient($ingredient_id) //get singular ingredient
    {
       $ingredients = Ingredients::where('ingredient_id', "=", $ingredient_id)->get();

        return response([
            'ingredients' => $ingredients
        ], 212);
    }


}
