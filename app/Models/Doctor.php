<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Doctor extends Model
{
    protected $fillable = ['nome', 'especialidade'];

    public function timeSlots()
    {
        return $this->hasMany(TimeSlot::class);
    }
}
