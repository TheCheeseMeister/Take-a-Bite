<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\RegisterRequest;
use App\Http\Requests\LoginRequest;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthenticationController extends Controller
{
    public function register(RegisterRequest $request){
        $request->validated();
        

        $userData = [
            'user_username' => $request->username,
            'user_email' => $request->email,
            'user_password' => Hash::make($request->password)
        ];


        $user = User::create($userData);
        $tokenResult = $user->createToken('TakeABite');
        $token = $tokenResult->plainTextToken;

        return response([
            'user' => $user,
            'token' => $token
        ], 201);

    }

    public function login(LoginRequest $request){
        $request->validated();

        #$user = User::whereUsername($request->user_username)->first();

        $user = User::where('user_username', $request->username)->first();

        if(!Hash::check($request->password, $user->user_password)){
            return response([
                'message' => 'Invalid hash'
            ], 422);
        }
        if(!$user || !Hash::check($request->password, $user->user_password)){
            return response([
                'message' => 'Invalid credentials'
            ], 422);
        }
        
        $tokenResult = $user->createToken('TakeABite');
        $token = $tokenResult->plainTextToken;


        return response([
            'user' => $user,
            'token' => $token
        ], 200);
    }
}
