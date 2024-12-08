<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class authController extends Controller
{
    public function showLoginForm()
    {
        return view('login');
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);
        $client = new Client();

        try {
            $response = $client->post('http://localhost:4000/auth/login', [
                'headers' => [
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                ],
                'json' => [
                    'email' => $request->input('email'),
                    'password' => $request->input('password'),
                ],
            ]);
            $body = json_decode($response->getBody(), true);
            $token = $body['token'];

            session(['token' => $token]);

            $userResponse = $client->get('http://localhost:4000/auth/me', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                ],
            ]);
            $userData = json_decode($userResponse->getBody(), true);
            if (isset($userData['data'][0][0]['role'])) {
                $role = $userData['data'][0][0]['role'];

                if ($role === 'admin') {
                    return redirect()->route('admin.home');
                } else {
                    return redirect()->route('home');
                }
            }
            return redirect()->route('login.form')->withErrors(['login' => 'Invalid user role.']);

        } catch (\Exception $e) {
            if ($e->getCode() == 400) {
                return back()->withErrors(['login' => 'Username or password is incorrect.'])->withInput();
            } else {
                return back()->withErrors(['login' => 'Login failed: ' . $e->getMessage()])->withInput();
            }
        }
    }

    public function logout(Request $request)
    {
        Auth::logout();
        $request->session()->invalidate();
        $request->session()->regenerateToken();

        if ($request->expectsJson()) {
            return response()->json(['success' => true]);
        }
        return redirect()->route('login.form');
    }
}
