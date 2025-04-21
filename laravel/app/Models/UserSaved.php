<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserSaved extends Model
{
   
    protected $table = 'TAB_user_recipe_save';
    protected $primaryKey = 'user_recipe_save_id';


    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'urs_user_id',
        'urs_recipe_id',
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



}
