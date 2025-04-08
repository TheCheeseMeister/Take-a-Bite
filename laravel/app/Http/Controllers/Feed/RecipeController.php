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
        ]);

        return response([
            'message' => 'success',
        ],201);
    }

    public function getRecipe($feed_id)
    {
        $recipe_name = Recipe::with('user')->where('recipe_id', "=", $feed_id)->latest()->get();

        return response([
            'recipe_name' => $recipe_name,
        ],200);
    }

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
    
    public function getIngredients($ingredient_id)
    {
       # $comments = Comment::whereFeedID($feed_id)->latest()->get();
        $ingredient = Ingredients::with('$TAB_ingredients')->where('ingredient_id', "=", $ingredient_id)->latest()->get();

        return response([
            'ingredient' => $ingredient
        ]);
    }


}
