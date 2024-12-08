<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Profile Admin</title>
    <link rel="stylesheet" href="{{ asset('css/adminProfile.css') }}" />
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
    <div class="main">
        <h1>Profile Admin</h1>
        <div class="containerDua">
            <div class="formContainer">
                <form id="registrationForm">
                    <div class="nameContainer">
                        <div>
                            <label for="Fname">First name</label><br />
                            <input type="text" name="Fname" id="Fname" readonly />
                            <span class="error" id="FnameError"></span>
                        </div>
                        <div>
                            <label for="Lname">Last name</label><br />
                            <input type="text" name="Lname" id="Lname" />
                            <span class="error" id="LnameError"></span>
                        </div>
                    </div>
                    <div class="emailContainer">
                        <label for="email">Email</label><br />
                        <input type="email" name="email" id="email" />
                        <span class="error" id="emailError"></span>
                    </div>
                    <div class="roleContainer">
                        <label for="role">Role</label><br />
                        <input type="text" name="role" id="role" />
                        <span class="error" id="emailError"></span>
                    </div>

                    <div class="btn-Container">
                        <div class="btnSubmit">
                            <button id="editAccountBtn">edit akun</button>
                        </div>
                        <div class="btnLogOut">
                            <button type="button" onclick="logout()">Logout</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Edit Profile</h2>
            <form id="userForm">
                <label for="updateFname">First Name:</label><br>
                <input type="text" id="updateFname" name="updateFname" >
                <br><br>
    
                <label for="updateLname">Last Name:</label><br>
                <input type="text" id="updateLname" name="updateLname" >
                <br><br>
    
                <label for="updateEmail">Email:</label><br>
                <input type="email" id="updateEmail" name="updateEmail" >
                <br><br>
                
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>
    
    {{-- <p id="passwordError" style="color: red; display: none;">Password dan konfirmasi password tidak sesuai</p> --}}

    <!-- Javascript -->
    <script src="{{ asset('js/adminProfile.js') }}"></script>
    <script>
        window.apiData = {
            userFound: @json($userFound)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
