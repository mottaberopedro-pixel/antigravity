<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\UbsService;
use App\Models\Doctor;
use App\Models\Patient;
use App\Models\TimeSlot;

class HealthSystemSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Criar Serviços da UBS
        UbsService::create([
            'nome' => 'Vacinação',
            'descricao' => 'Vacinação de rotina e campanhas contra Gripe, COVID e outras.'
        ]);
        UbsService::create([
            'nome' => 'Clínico Geral',
            'descricao' => 'Atendimento médico preventivo e consultas básicas.'
        ]);
        UbsService::create([
            'nome' => 'Odontologia',
            'descricao' => 'Cuidado com a saúde bucal e pequenos procedimentos.'
        ]);

        // 2. Criar Médicos
        $doctor1 = Doctor::create(['nome' => 'Dr. Ricardo Silva', 'especialidade' => 'Clínico Geral']);
        $doctor2 = Doctor::create(['nome' => 'Dra. Ana Maria', 'especialidade' => 'Pediatria']);

        // 3. Criar Paciente Exemplo
        Patient::create([
            'nome' => 'João da Silva',
            'cpf' => '123.456.789-00',
            'cartao_sus' => '700000000000000',
            'data_nascimento' => '1990-05-20',
            'agente_responsavel' => 'Agente Marcos Souza'
        ]);

        // 4. Criar Horários Disponíveis
        TimeSlot::create([
            'doctor_id' => $doctor1->id,
            'data' => '2026-05-20',
            'hora' => '09:00',
            'disponivel' => true
        ]);
        TimeSlot::create([
            'doctor_id' => $doctor1->id,
            'data' => '2026-05-20',
            'hora' => '10:00',
            'disponivel' => true
        ]);
        TimeSlot::create([
            'doctor_id' => $doctor2->id,
            'data' => '2026-05-21',
            'hora' => '14:00',
            'disponivel' => true
        ]);
    }
}
