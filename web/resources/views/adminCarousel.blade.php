<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Carousel Settings</title>
    <link rel="stylesheet" href="{{ asset('css/adminCarousel.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />
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
    <div class="tableData">
        <h1>Data Carousel</h1>
        <table id="carouselTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Foto</th>
                    <th>Title</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>
    <div class="tambahCarousel">
        <button id="tambahBtn">Tambah Data Carousel</button>
    </div>

    <!-- Modal Pop-up -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Tambah Data Carousel</h2>
            <form id="carouselForm">
                <label for="title">Nama:</label><br>
                <input type="text" id="title" name="title" required>
                <br><br>

                <label for="carousel_img">Foto:</label><br>
                <input type="file" id="carousel_img" name="carousel_img" accept="image/*" required>
                <br><br>

                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>

    <script src="{{ asset('js/adminCarousel.js') }}"></script>
    <script>
        window.apiData = {
            DataCarousel: @json($dataCarousel)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
