<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Laporan User</title>
    <link rel="stylesheet" href="{{ asset('css/adminUser.css') }}" />
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

    {{-- CONTENT --}}
    <div class="tableData">
        <h1>Data User</h1>
        <table id="carouselTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>Nama</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="tambahUser">
        <button id="tambahBtn">Tambah Data User</button>
    </div>

    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Tambah Pengguna</h2>
            <form id="userForm">
                <label for="first_name">First Name:</label><br>
                <input type="text" id="first_name" name="first_name" >
                <br><br>
    
                <label for="last_name">Last Name:</label><br>
                <input type="text" id="last_name" name="last_name" >
                <br><br>
    
                <label for="email">Email:</label><br>
                <input type="email" id="email" name="email" >
                <br><br>
    
                <label for="password">Password:</label><br>
                <input type="password" id="password" name="password" >
                <br><br>
    
                <label for="confirm_password">Konfirmasi Password:</label><br>
                <input type="password" id="confirm_password" name="confirm_password" >
                <p id="passwordError" style="color: red; display: none;">Password dan konfirmasi password tidak sesuai</p>
    
                <div class="margin"></div>
                <label for="role">Role:</label><br>
                <select id="role" name="role" >
                    <option value="">-- Pilih Role --</option>
                    <option value="admin">Admin</option>
                    <option value="pelanggan">Pelanggan</option>
                </select>
                <br><br>
    
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>
    

    <!-- Javascript -->
    <script src="{{ asset('js/adminUser.js') }}"></script>
    <script>
        window.apiData = {
            dataUser: @json($dataUser)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
