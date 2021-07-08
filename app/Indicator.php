<?php

namespace App;

use Illuminate\Database\Eloquent\Model;
use App\Form;
use App\Form_item;

class Indicator extends Model
{
    //
    public $timestamps = false;

    public function scopeParams($query)
    {
        return $query->where('votes', '>', 100);
    }

    public function scopeWomen($query)
    {
        return $query->whereGender('W');
    }
}
