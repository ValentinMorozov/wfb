<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Auth::routes();

/*Route::get('/', function () {  return redirect()->route('reports');   })->name('home');*/
Route::get('/','ReportsController@index')->name('home');
Route::get('home', function () {  return redirect()->route('home');   });
Route::post('ajax/getdata', 'ReportsController@AjaxGetData');
Route::get('ajax/getdata', 'ReportsController@AjaxGetData');
Route::prefix('reports')->group(function () {

/*
    Route::get('{parent_id?}','EntityController@index')->name('entity')->middleware('checkrole:isSuperAdmin');
    Route::get('ajax/nodechild/{parent_id}','EntityController@nodeChild')->middleware('checkrole:isSuperAdmin');
    Route::post('ajax/save','EntityController@save')->middleware('checkrole:isSuperAdmin');
    Route::get('ajax/show/{entity}','EntityController@show')->middleware('checkrole:isSuperAdmin');
    Route::get('ajax/gettree','EntityController@getTree')->middleware('checkrole:isSuperAdmin');

    Route::get('create','EntityController@create');
    Route::get('store','EntityController@store');

    Route::get('edit','EntityController@edit');
    Route::get('update','EntityController@update');
    Route::get('destroy','EntityController@destroy');
*/
});

