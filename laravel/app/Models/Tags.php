<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Tags extends Model
{
    public $timestamps = false;
    protected $table = 'TAB_tags';
    protected $primaryKey = 'tags_id';


    protected $fillable = [
        'tag_id',
        'ingredients_id',
    ];

    public function recipeTags(): HasMany
    {
	return $this->hasMany(TagRecipe::class, 'tags_id', 'tags_id');
    }


}
