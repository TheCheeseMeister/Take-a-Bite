<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class MealPlanRecipeRequest extends FormRequest
{

    
    protected $table = 'TAB_meal_plan_recipes';
    protected $primaryKey = 'mp_recipes_id';



    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            'mp_id' => 'required',
            'recipe_id' => 'required',
        ];
    }
}
