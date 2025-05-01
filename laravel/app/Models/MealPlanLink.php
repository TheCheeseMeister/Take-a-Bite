<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MealPlanLink extends Model
{
    
    use HasFactory;

    public $timestamps = false;
    protected $table = 'TAB_mealplan_user_recipe';
    protected $primaryKey = 'mur_id';


    protected $fillable = [
            'mur_user_id',
            'mur_recipe_id',
            'mur_mealplan_id',
    ];

    public function user(): BelongsTo{
        return $this->belongsTo(User::class, 'mur_user_id', 'user_id');
    }

    public function recipe(): BelongsTo
    {
	return $this->belongsTo(Recipe::class, 'mur_recipe_id', 'recipe_id');
    }

    public function plan(): BelongsTo
    {
	return $this->belongsTo(MealPlan::class, 'mur_mealplan_id', 'meal_plan_id');
    }


}
