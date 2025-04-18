<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Ingredients extends Model
{
    
    use HasFactory;

    protected $table = 'TAB_ingredients';
    public $timestamps = false;

    protected $fillable = [
        'ingredient_name',
        'ingredient_allergen'
    ];

    public function feed(): BelongsTo
    {
        return $this->belongsTo(Recipe::class);
    }

}
