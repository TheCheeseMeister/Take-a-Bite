<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserSavedRequest extends FormRequest
{
    
    protected $table = 'TAB_user_recipe_save';
    protected $primaryKey = 'user_recipe_save_id';
    
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
            'urs_user_id' => 'required',
            'urs_recipe_id' => 'required'
        ];
    }


}
