<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Requests\PostRequest;
use App\Models\Feed;
use App\Models\Like;

class FeedController extends Controller
{

    public function index(Request $request)
    {
        $feeds = Feed::with('user')->latest()->get();
        return response([
            'feeds' => $feeds

        ], 200);
    }


    public function store(PostRequest $request){
        $request->validated();

        auth()->user()->feeds()->create([
            'content' => $request->content,
        ]);

        return response([
            'message' => 'success',
        ],201);
    }

    public function likePost($feed_id)
    {
        $feed = Feed::where('id', '=', $feed_id)->first();

        
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
        

        /*
        if($feed->user_id == auth()->user()->id){
            Like::where('id', '=',$feed_id)->delete();
            return response([
                'message'=> 'UnLiked'
                ],200);
        }
        else{
            Like::create([
                'user_id' => auth()->id,
                'feed_id' => $feed_id,
            ]);
            return response([
                'message'=> 'Liked',
                ],200);

        }
*/
    }

}
