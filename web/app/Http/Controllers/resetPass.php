<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;

class resetPass extends Controller
{
    public function showResetPasswordForm($token)
    {
        session(['token' => $token]);
        $userData = $this->me($token);
        return view('resetPassword', ['token' => $token, 'userData' => $userData]);
    }

    public function me($token)
    {
        $client = new Client();
        if (!$token) {
            return redirect()->route('login.form');
        }

        try {
            $userResponse = $client->get('http://localhost:4000/auth/me', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                ],
            ]);
            $userData = json_decode($userResponse->getBody(), true);
            if (isset($userData['data'][0][0])) {
                $user = $userData['data'][0][0];
                return $user;
            } else {
                return redirect()->route('login.form')->withErrors(['login' => 'User data not found.']);
            }
            return redirect()->route('login.form')->withErrors(['login' => 'User data not found.']);
        } catch (\Throwable $th) {
            return redirect()->route('home')->withErrors(['data' => 'Data tidak ditemukan.' . $th->getMessage()]);
        }

    }

    public function requestResetPass(Request $request)
    {
        try {
            $client = new Client();
            $response = $client->post('http://localhost:4000/user/forgetPassword', [
                'headers' => [
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            $result = json_decode($response->getBody(), true);
            session(['token' => $result['token']]);
            if ($result['success']) {
                return response()->json(['success' => true, 'message' => $result['message']]);
            }
        } catch (\Throwable $th) {
            return response()->json(['success' => false, 'error' => 'gagal mengirimkan permintaan: ' . $th->getMessage()]);
        }
    }

    public function resetPassword(Request $request)
    {
        try {
            $client = new Client();
            $token = session('token') ?? $request->input('token');

            if (!$token) {
                return response()->json(['success' => false, 'message' => 'Token JWT tidak ditemukan'], 401);
            }

            $response = $client->post('http://localhost:4000/user/changePassword', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
                'json' => [
                    'id_user' => $request->input('id_user'),
                    'newPass' => $request->input('newPassword')
                ],
            ]);

            $result = json_decode($response->getBody(), true);

            return response()->json(['success' => true, 'message' => 'password berhasil diubah']);
        } catch (\Throwable $th) {
            return response()->json(['success' => false, 'error' => 'Terjadi kesalahan: ' . $th->getMessage()], 500);
        }

    }
}
