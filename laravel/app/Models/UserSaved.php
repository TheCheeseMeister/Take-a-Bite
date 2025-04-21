<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;


class UserSaved extends Model
{
   
    protected $table = 'TAB_user_recipe_save';
    protected $primaryKey = 'user_recipe_save_id';
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'urs_user_id',
        'urs_recipe_id',
	'urs_date_saved',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'urs_date_saved' => 'datetime',
        ];
    }

    // Relationship to Recipe
    public function recipe(): BelongsTo
    {
	return $this->belongsTo(Recipe::class, 'urs_recipe_id');
    }



}
