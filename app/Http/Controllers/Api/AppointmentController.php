<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TimeSlot;
use Illuminate\Http\JsonResponse;

class AppointmentController extends Controller
{
    public function availableSlots(): JsonResponse
    {
        // Pega todos os horários que estão marcados como disponíveis e traz o médico junto
        $slots = TimeSlot::with('doctor')
            ->where('disponivel', true)
            ->get();
            
        return response()->json([
            'vagas' => $slots->map(function($slot) {
                return [
                    'id' => $slot->id,
                    'medico' => $slot->doctor->nome,
                    'especialidade' => $slot->doctor->especialidade,
                    'data' => $slot->data,
                    'hora' => $slot->hora
                ];
            })
        ]);
    }
}
