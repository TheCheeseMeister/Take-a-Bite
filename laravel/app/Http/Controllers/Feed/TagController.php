<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use Illuminate\Http\TagRequest;
use Illuminate\Http\Request;
use App\Models\Tags;


class TagController extends Controller
{
    
    protected $table = 'TAB_tags';
    protected $primaryKey = 'tags_id';


    public function getTag($tags_id)
    {
        $table = 'TAB_tags';
        $primaryKey = 'tags_id';
        $tag_name = Tags::where('tags_id', "=", $tags_id)->get();

        return response([
            'tag_name' => $tag_name,
        ],200);
    }

    public function getTags()
    {
        $table = 'TAB_tags';
        $primaryKey = 'tags_id';
        $tag_name = Tags::get();

        return response([
            'tag_name' => $tag_name,
        ],200);
    }



}
