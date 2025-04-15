<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagIngredient extends Model
{
    public $timestamps = false;
    protected $table = 'TAB_tags_ingredients';
    protected $primaryKey = 'tags_ingredients_id';


    protected $fillable = [
        'tags_id',
        'ingredients_id',
    ];


}
