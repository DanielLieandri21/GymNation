<?php

use App\Http\Controllers\authController;
use App\Http\Controllers\carouselController;
use App\Http\Controllers\dataGymController;
use App\Http\Controllers\pengaudanController;
use App\Http\Controllers\profileController;
use App\Http\Controllers\resetPass;
use App\Http\Controllers\userController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
 */

Route::get('/', [carouselController::class, 'mainCarousel'], function () {
    return view('home');
})->name('home');
Route::post('/addPengaduan', [pengaudanController::class, 'addPengaduan'])->name('addPengaduan.process');

Route::get('/admin', function () {
    return view('login');
})->name('login.form');
Route::post('/login', [authController::class, 'login'])->name('login.process');
Route::post('/logout', [authController::class, 'logout'])->name('logout');

Route::get('/registerPage', function () {
    return view('register');
})->name('register.form');
Route::post('/createAccount', [userController::class, 'createAccount'])->name('createdAccount.pelanggan');


Route::post('/requestResetPassword', [resetPass::class, 'requestResetPass'])->name('requestReset.password');
Route::get('/resetPassword/{token}', [resetPass::class, 'showResetPasswordForm'])->name('resetPassword');
Route::post('/resetPassword/{token}', [resetPass::class, 'resetPassword'])->name('reset.password');

Route::middleware(['checkLogin'])->group(function () {
    
    Route::get('/admin/Home', [dataGymController::class, 'homeAdmin'],function () {
        return view('adminHome');
    })->name('admin.home');
    Route::post('/admin/editStatusGYM', [dataGymController::class, 'editStatusGYM'])->name('admin.editStatusGYM');

    Route::get('/admin/Laporan', [pengaudanController::class, 'mainLaporan'], function () {
        return view('adminLaporan');
    })->name('admin.laporan');
    Route::delete('/admin/deleteLaporan', [pengaudanController::class, 'deletePengaduan'])->name('admin.deletePengaduan');
    
    Route::get('/admin/carouselSettings', [carouselController::class, 'adminMainCarousel'], function () {
        return view('adminCarousel');
    })->name('admin.carousel');
    Route::delete('/admin/deleteCarousel', [carouselController::class, 'deleteCarousel'])->name('admin.deleteCarousel');
    Route::post('/admin/addCarousel', [carouselController::class, 'addCarousel'])->name('admin.addCarousel');
    
    Route::get('/admin/profile', [profileController::class, 'profileAdmin'], function () {
        return view('adminProfile');
    })->name('admin.profile');
    Route::post('/admin/editProfile', [profileController::class, 'updateProfile'])->name('admin.updateProfile');

    Route::get('/admin/dataGYM', [dataGymController::class, 'mainDataGYM'], function () {
        return view('adminDataGYM');
    })->name('admin.dataGYM');
    Route::delete('/admin/deleteFasilitas', [dataGymController::class, 'deleteFasilitas'])->name('admin.deleteFasilitas');
    Route::delete('/admin/deleteMakanan', [dataGymController::class, 'deleteMakanan'])->name('admin.deleteMakanan');
    Route::delete('/admin/deleteKelas', [dataGymController::class, 'deleteKelas'])->name('admin.deleteKelas');
    Route::delete('/admin/deletePotonganHarga', [dataGymController::class, 'deletePotonganHarga'])->name('admin.deletePotonganHarga');
    Route::post('/admin/addFasilitas', [dataGymController::class, 'addFasilitas'])->name('admin.addFasilitas');
    Route::post('/admin/addMakanan', [dataGymController::class, 'addMakanan'])->name('admin.addMakanan');
    Route::post('/admin/editAnggotaKelas', [dataGymController::class, 'editAnggotaKelas'])->name('admin.editAnggotaKelas');
    Route::post('/admin/editHariKelas', [dataGymController::class, 'editHariKelas'])->name('admin.editHariKelas');
    Route::post('/admin/addKelas', [dataGymController::class, 'addKelas'])->name('admin.addKelas');
    Route::post('/admin/addPotonganHarga', [dataGymController::class, 'addPotonganHarga'])->name('admin.addPotonganHarga');

    Route::get('/admin/user', [userController::class, 'userReports'],function () {
        return view('adminUser');
    })->name('admin.user');
    Route::delete('/admin/deleteUser', [userController::class, 'deleteUser'])->name('admin.deleteUser');
    Route::post('/admin/tambahUser', [userController::class, 'addUser'])->name('admin.addUser');
});
