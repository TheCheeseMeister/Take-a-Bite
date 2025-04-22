<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MealPlan extends Model
{
    
    use HasFactory;

    protected $table = 'TAB_meal_plan';
    protected $primaryKey = 'meal_plan_id';

    public $timestamps = false;

    protected $fillable = [
        'date_to_make',
        'time_to_make',
    ];

    public function user(): BelongsTo{
        return $this->belongsTo(User::class);
    }


}
