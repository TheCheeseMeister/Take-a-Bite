<?php

namespace App\Http\Controllers\Feed;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use App\Http\Requests\UserRequest;

class UserController extends Controller
{
    /**
     * Get all Users.
     */
    public function getUsers(Request $request)
    {
        $users = User::all();
	return response([
		'users' => $users,
	], 200);
    }

    /**
     * Get user by id.
     */
    public function getUser($user_id)
    {
	$user = User::where('user_id', "=", $user_id)->first();
	
	return response([
	    'user' => $user,
	], 200);
    }

    public function storeProfilePicture(Request $request)
    {
	$imagePath = NULL;
        if ($request->hasFile('image') && $request->file('image')->isValid()) {
            $path = $request->file('image')->store('images/profile', 'public');
            $imagePath = url('storage/' . $path);
        }

	$user = User::where('user_id', "=", $request->user_id)->first();

	if ($imagePath) {
	    $user->user_profile_picture = $imagePath;
	    $user->save();
	}

	return response([
	    'user' => $user,
	], 200);
    }

    public function storeProfileBio(Request $request)
    {
	$user = User::where('user_id', "=", $request->user_id)->first();

	$user->user_bio = $request->bio;
	$user->save();

	return response([
	    'user' => $user,
	], 200);
    }
}
