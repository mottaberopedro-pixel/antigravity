<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TimeSlot extends Model
{
    protected $fillable = ['doctor_id', 'data', 'hora', 'disponivel'];

    public function doctor()
    {
        return $this->belongsTo(Doctor::class);
    }
}
