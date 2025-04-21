<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MealPlanUser extends Model
{
    
    use HasFactory;

    protected $table = 'TAB_meal_plan_user';
    protected $primaryKey = 'mp_user_id';
    public $timestamps = false;

    protected $fillable = [
        'mp_id',
        'user_id',
    ];

    public function user(): BelongsTo{
        return $this->belongsTo(User::class);
    }


}
