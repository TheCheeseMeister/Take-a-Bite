<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagRecipe extends Model
{
   
    public $timestamps = false;
    protected $table = 'TAB_tags_recipes';
    protected $primaryKey = 'tags_recipes_id';


    protected $fillable = [
        'tags_id',
        'recipe_id',
    ];

}
