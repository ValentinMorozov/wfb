<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Support\Facades\Auth;

class User extends Authenticatable
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];
    public function isSuperAdmin()
    {
        if (Auth::check()) {
            if(Auth::user()->name === 'admin')
                return true;
        }
        return false;
    }
    public function hasRole($role)
    {
        switch($role) {
            case 'isSuperAdmin' : return $this->isSuperAdmin();
            default: return false;
        }

    }
}
