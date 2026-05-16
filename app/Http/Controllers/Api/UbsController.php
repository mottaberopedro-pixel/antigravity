<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UbsService;
use Illuminate\Http\JsonResponse;

class UbsController extends Controller
{
    public function services(): JsonResponse
    {
        $services = UbsService::all();
        
        return response()->json([
            'unidade' => 'UBS Central',
            'servicos' => $services
        ]);
    }
}
