<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use GuzzleHttp\Client;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Log;

class carouselController extends Controller
{
    public function mainCarousel()
    {
        $dataCarousel = $this->getAllDataCarousel();

        return view('home', ['dataCarousel' => $dataCarousel]);
    }

    public function adminMainCarousel()
    {
        $dataCarousel = $this->getAllDataCarousel();

        return view('adminCarousel', ['dataCarousel' => $dataCarousel]);
    }

    public function getAllDataCarousel()
    {
        $client = new Client();

        try {
            $response = $client->get('http://localhost:4000/carousel/getCarousel');
            $data = json_decode($response->getBody(), true);
            return $data;
        } catch (\Throwable $th) {
            return redirect()->route('home')->withErrors(['data' => 'Data tidak ditemukan.' . $th->getMessage()]);
        }
    }

    public function deleteCarousel(Request $request)
    {
        $token = session('token');

        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $carouselID = $request->input('id_carousel');

        if (!$carouselID) {
            return response()->json(['success' => false, 'error' => 'User ID is required'], 400);
        }

        try {
            $client = new Client();
            $response = $client->delete("http://localhost:4000/carousel/deleteCarousel/{$carouselID}", [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
                'json' => $request->all(),
            ]);

            return response()->json(['success' => true, 'message' => 'Carousel berhasil dihapus']);
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'gagal menghapus carousel: ' . $e->getMessage()]);
        }
    }

    public function addCarousel(Request $request)
    {
        $token = session('token');
        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        try {
            $client = new Client();
            $response = $client->post('http://localhost:4000/carousel/addCarousel', [
                'headers' => [
                    'Authorization' => "Bearer {$token}",
                    'Accept' => 'application/json',
                ],
                'multipart' => [
                    [
                        'name' => 'title',
                        'contents' => $request->input('title'),
                    ],
                    [
                        'name' => 'carousel_img',
                        'contents' => fopen($request->file('carousel_img')->getPathname(), 'r'),
                        'filename' => $request->file('carousel_img')->getClientOriginalName(),
                    ],
                ],
            ]);

            $responseBody = json_decode($response->getBody(), true);
            if ($responseBody['success']) {
                return response()->json(['success' => true, 'message' => 'Carousel berhasil ditambahkan']);
            } else {
                return response()->json(['success' => false, 'error' => 'Gagal menambahkan carousel']);
            }
        } catch (\Throwable $e) {
            return response()->json(['success' => false, 'error' => 'Terjadi kesalahan: ' . $e->getMessage()]);
        }
    }

}
