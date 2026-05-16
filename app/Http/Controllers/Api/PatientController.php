<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Patient;
use Illuminate\Http\JsonResponse;

class PatientController extends Controller
{
    public function profile(): JsonResponse
    {
        // Retorna o primeiro paciente como exemplo (já que não há login implementado ainda)
        $patient = Patient::first();
        
        if (!$patient) {
            return response()->json(['error' => 'Nenhum paciente encontrado.'], 404);
        }
        
        return response()->json([
            'paciente' => $patient
        ]);
    }
}
