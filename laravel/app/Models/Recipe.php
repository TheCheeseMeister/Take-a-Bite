<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Recipe extends Model
{

    use HasFactory;

    protected $table = 'TAB_recipes';
    protected $primaryKey = 'recipe_id';


    protected $fillable = [
        'recipe_name',
        'cook_time',
        'prep_time',
        'recipe_description',
        'recipe_category',
        'recipe_servings',
        'recipe_yield',
        'recipe_directions',
	'recipe_image',
    ];

    //protected $appends = ['liked'];

    public function user(): BelongsTo{
        return $this->belongsTo(User::class);
    }

       /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'created_at' => 'datetime'
        ];
    }

    public function likes(): HasMany
    {
        return $this->hasMany(Like::class);

    }
    public function comments(): HasMany
    {
        return $this->hasMany(Comment::class);

    }

    public function ingredients(): HasMany
    {
	return $this->hasMany(RecipeIngredients::class, 'ri_recipe_id', 'recipe_id');
    }

    public function tags(): HasMany
    {
	return $this->hasMany(TagRecipe::class, 'recipe_id', 'recipe_id');
    }
/*
    public function getLikedAttribute(): bool
    {
        return (bool) $this->likes()->where('recipe_id', $this->id)->where('user_id', $this->user_id)->exists();
    }
*/
}
