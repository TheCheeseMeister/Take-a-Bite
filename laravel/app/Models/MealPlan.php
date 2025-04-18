<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MealPlan extends Model
{
    
    use HasFactory;

    protected $table = 'TAB_recipes';
    protected $primaryKey = 'recipe_id';


    protected $fillable = [
        'date_to_make',
        'time_to_make',
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

}
