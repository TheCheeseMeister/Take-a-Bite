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
            'recipe_name' => 'required|string',
            'cook_time' => 'required|string',
            'prep_time' => 'required|string',
            'total_time' => 'required|string',
            'recipe_description' => 'nullable|string',
            'recipe_category' => 'string',
            'recipe_servings' => 'required|string',
            'recipe_yield' => 'required|string',
            'recipe_directions' => 'required|string',
	    'recipe_image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
            'is_public' => 'boolean',
	];
    }
}
