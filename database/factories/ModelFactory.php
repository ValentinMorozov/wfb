<?php

use Faker\Generator as Faker;

/*
|--------------------------------------------------------------------------
| Model Factories
|--------------------------------------------------------------------------
|
| This directory should contain each of the model factory definitions for
| your application. Factories provide a convenient way to generate new
| model instances for testing / seeding your application's database.
|
*/

$factory->define(App\User::class, function (Faker $faker) {
    static $password;

    return [
        'name' => $faker->name,
        'email' => $faker->unique()->safeEmail,
        'password' => $password ?: $password = bcrypt('secret'),
        'remember_token' => str_random(10),
    ];
});
$factory->define(App\Post::class, function (Faker $faker) { 
// Get a random user 
	$user = \App\User::inRandomOrder()->first(); 
// generate fake data for post
	return [ 
		'user_id' => isset($user) ? $user->id : 0,
		'title' => $faker->sentence,
		'body' => $faker->text, 
		]; 
});