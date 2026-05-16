<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UbsController;
use App\Http\Controllers\Api\AppointmentController;
use App\Http\Controllers\Api\PatientController;

/*
|--------------------------------------------------------------------------
| API Routes - SV Saude Virtual
|--------------------------------------------------------------------------
*/

// 1. Rota de Status
Route::get('/status', function () {
    return response()->json([
        'status' => 'online',
        'mensagem' => 'API SV Saude Virtual operando corretamente.',
        'versao' => '2.0.0 (Functional)'
    ]);
});

// 2. Rota de Serviços da UBS (Usa o banco de dados)
Route::get('/ubs/servicos', [UbsController::class, 'services']);

// 3. Rota de Vagas Disponíveis (Usa o banco de dados)
Route::get('/vagas/disponiveis', [AppointmentController::class, 'availableSlots']);

// 4. Rota do Perfil do Paciente (Usa o banco de dados)
Route::get('/paciente/perfil', [PatientController::class, 'profile']);
