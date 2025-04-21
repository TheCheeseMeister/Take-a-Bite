<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;


class MealPlanRecipe extends Model
{
        
    use HasFactory;

    protected $table = 'TAB_meal_plan_recipes';
    protected $primaryKey = 'mp_recipes_id';
    public $timestamps = false;

    protected $fillable = [
        'mp_id',
        'recipe_id',
    ];

    public function user(): BelongsTo{
        return $this->belongsTo(User::class);
    }

}
