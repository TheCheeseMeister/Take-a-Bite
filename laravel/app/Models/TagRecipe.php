<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TagRecipe extends Model
{
   
    public $timestamps = false;
    protected $table = 'TAB_tags_recipes';
    protected $primaryKey = 'tags_recipes_id';


    protected $fillable = [
        'tags_id',
        'recipe_id',
    ];

    public function tag(): BelongsTo
    {
	return $this->belongsTo(Tags::class, 'tags_id', 'tags_id');
    }

    public function recipe(): HasMany
    {
	return $this->hasMany(Recipe::class, 'recipe_id');
    }

}
