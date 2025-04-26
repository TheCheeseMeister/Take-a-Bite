<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserIngredientsRequest extends FormRequest
{
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
            'ui_ingredient_id' => 'required',
            'ui_user_id' => 'required',
            'ui_expiration_date' => '',
            'ui_ingredient_amount' => '',
        ];
    }
}
