<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;

class pengaudanController extends Controller
{


    public function mainLaporan(){
        $token = session('token');
        $data = $this->getLaporan($token);

        return view('adminLaporan', ['dataPengaduan' => $data]);
    }

    public function getLaporan($token){
        $client = new Client();


        try {
            $response = $client->get('http://localhost:4000/pengaduan/getAllLaporan', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                ],  
            ]);
            $data = json_decode($response->getBody(), true);
            return $data;
        } catch (\Throwable $th) {
            return redirect()->route('admin.home')->withErrors(['data' => 'Data tidak ditemukan.' . $th->getMessage()]);
        }
    }

    public function addPengaduan(Request $request)
    {
        try {
            $client = new Client();
            $response = $client->post('http://localhost:4000/pengaduan/addPengaduan', [
                'headers' => [
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            $result = json_decode($response->getBody(), true);

            if ($result['success']) {
                return response()->json(['success' => true, 'message' => $result['message']]);
            }

            return response()->json(['success' => false, 'error' => $result['error'] ?? 'Terjadi kesalahan.']);
        } catch (\Throwable $th) {
            return response()->json(['success' => false, 'error' => 'gagal menambahkan pengaduan: ' . $th->getMessage()]);
        }
    }

    public function deletePengaduan(Request $request)
    {
        $token = session('token');
        
        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }
        
        $pengaduanID = $request->input('id_Pengaduan');
        
        if (!$pengaduanID) {
            return response()->json(['success' => false, 'error' => 'User ID is required'], 400);
        }

        try {
            $client = new Client();
            $response = $client->delete("http://localhost:4000/pengaduan/deletePengaduan/{$pengaduanID}", [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
               'json' => $request->all(), 
            ]);

            return response()->json(['success' => true, 'message' => 'Pelamar berhasil dihapus']);
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'gagal menghapus pelamar: ' . $e->getMessage()]);
        }
    }
}
