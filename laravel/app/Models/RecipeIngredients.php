<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class RecipeIngredients extends Model
{

    use HasFactory;

    public $timestamps = false;
    protected $table = 'TAB_recipes_ingredients';
    protected $primaryKey = 'recipes_ingredients_id';


    protected $fillable = [
        'ri_recipe_id',
        'ri_ingredient_id',
        'ri_ingredient_measurement'
    ];


    public function recipe(): HasMany
    {
        return $this->hasMany( Recipe::class);
    }

    public function ingredients(): HasMany
    {
        return $this->hasMany( Ingredients::class);
    }

}
