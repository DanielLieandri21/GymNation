<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;

class userController extends Controller
{
    public function userReports()
    {
        $token = session('token');
        $userReportsData = $this->getAllDataUser($token);
        return view('adminUser', ['dataUser' => $userReportsData]);

    }

    public function getAllDataUser($token)
    {
        $client = new Client();

        try {
            $response = $client->get('http://localhost:4000/user/getAllUser', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                ],
            ]);
            $data = json_decode($response->getBody(), true);
            return $data;
        } catch (\Throwable $th) {
            return redirect()->route('admin.user')->withErrors(['data' => 'Data tidak ditemukan.' . $th->getMessage()]);
        }
    }

    public function deleteUser(Request $request)
    {
        $token = session('token');

        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $idUser = $request->input('id_user');
        if (!$idUser) {
            return response()->json(['success' => false, 'error' => 'User ID is required'], 400);
        }

        try {
            $client = new Client();
            $response = $client->delete("http://localhost:4000/user/deleteUser/{$idUser}", [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            return response()->json(['success' => true, 'message' => 'user berhasil dihapus']);
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'gagal menghapus user: ' . $e->getMessage()]);
        }
    }

    public function addUser(Request $request)
    {
        $token = session('token');

        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        try {
            $client = new Client();
            $response = $client->post("http://localhost:4000/user/addUser", [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            return response()->json(['success' => true, 'message' => 'user berhasil ditambahkan']);
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'gagal menambahkan user: ' . $e->getMessage()]);
        }
    }

    public function createAccount(Request $request)
    {
        try {
            $client = new Client();
            $response = $client->post("http://localhost:4000/user/addPelanggan", [
                'headers' => [
                    'Accept' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            return response()->json(['success' => true, 'message' => 'berhasil membuat akun']);
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'gagal membuat akun: ' . $e->getMessage()]);
        }
    }

}
