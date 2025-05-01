<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserIngredients extends Model
{
    
    protected $table = 'TAB_user_ingredients';
    protected $primaryKey = 'user_ingredient_id';
    public $timestamps = false;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'ui_ingredient_id',
        'ui_user_id',
	    'ui_expiration_date',
	    'ui_ingredient_amount',
    ];



}
