<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class MealPlanUserRequest extends FormRequest
{

    
    protected $table = 'TAB_meal_plan_user';
    protected $primaryKey = 'mp_user_id';



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
            'user_id' => 'required',
        ];
    }
}
