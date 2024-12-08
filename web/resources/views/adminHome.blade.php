<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Home Admin</title>
    <link rel="stylesheet" href="{{ asset('css/adminHome.css') }}" />
</head>
<body>
    <nav class="navbar">
        <a href="/admin/Home" class="brand">selamat datang</a>
        <div class="nav-container">
            <div class="nav-links">
                <a href="/admin/carouselSettings" class="nav-item"> carousel </a>
                <a href="/admin/Laporan" class="nav-item"> Laporan </a>
                <a href="/admin/user" class="nav-item"> User </a>
                <a href="/admin/dataGYM" class="nav-item"> Data GYM </a>
                <a href="/admin/profile" class="nav-item"> Profil </a>
            </div>
        </div>
    </nav>
    <h1 class="title">Admin Page Gymnation</h1>
    <div class="containerStatus">
        <div class="statusGYM">
            <div class="status-indicator">
                <span class="status-circle closed"></span>
                <span class="status-text">Gym Closed</span>
            </div>
            <div class="status-update">
                <label for="statusDropdown">PIlih Status:</label>
                <select id="statusDropdown">
                    <option value="" disabled selected>Silahkan pilih status gym</option> 
                    <option value="open">Open</option>
                    <option value="closed">Closed</option>
                </select>
                <button id="submitBtn">Kirim</button>
            </div>
        </div>

    </div>
    
    <div class="img">
        <img class="GymnationLogo" src="{{ asset('assets/icon-appbar.png') }}" alt="Gymnation Logo" />
    </div>
    
    <script src="{{ asset('js/adminHome.js') }}"></script>
    <script>
        window.apiData = {
            statusGYM: @json($statusGYM)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>