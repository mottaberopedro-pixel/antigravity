<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Patient extends Model
{
    protected $fillable = ['nome', 'cpf', 'cartao_sus', 'data_nascimento', 'agente_responsavel'];
}
