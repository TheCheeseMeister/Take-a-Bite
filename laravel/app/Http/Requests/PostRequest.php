<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class PostRequest extends FormRequest
{
    protected $table = 'TAB_recipes';
    protected $primaryKey = 'recipe_id';
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
            'recipe_name' => 'required|string|min:2',
            'cook_time' => 'required|string|min:2',
            'prep_time' => 'required|string|min:2',
            'total_time' => 'required|string|min:2',
            'recipe_description' => 'string',
            'recipe_category' => 'string|min:2',
            'recipe_servings' => 'required|string',
            'recipe_yield' => 'required|string|min:2',
            'recipe_directions' => 'required|string',
        ];
    }
}
