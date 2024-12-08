<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Register Page</title>
    <link rel="stylesheet" href="{{ asset('css/register.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />
    <!-- feather icons -->
    <script src="https://unpkg.com/feather-icons"></script>

</head>

<body>
    <nav class="navbar">
        <a href="/" class="navbar-logo">
            <img src="{{ asset('assets/icon-appbar.png') }}" alt="Gymnation Logo" />
        </a>
        <div class="navbar-nav">
            <a href="/">Home</a>
            <a href="/">Our Program</a>
            <a href="/">Our Class</a>
            <a href="/">Contact</a>
            <a href="/registerPage">
                <button class="btn-resgist">Register</button>
            </a>
        </div>
        <div class="navbar-extra">
            {{-- <a href="#" id="search"><i data-feather="search"></i></a> --}}
            <a href="#" id="hamburger-menu"><i data-feather="menu"></i></a>
        </div>
    </nav>

    {{-- CONTENT --}}
    <div class="main">
        <h1>Ayo segera daftarkan diri anda menjadi member</h1>
        <div class="containerDua">
            <div class="formContainer">
                <form id="registrationForm">
                    <div class="nameContainer">
                        <div>
                            <label for="Fname">First name</label><br />
                            <input type="text" name="Fname" id="Fname" />
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
                    <div class="passwordContainer">
                        <label for="password">Password</label><br />
                        <input type="password" name="password" id="password" />
                        <span class="error" id="passwordError"></span>
                    </div>
                    <div class="confirmPassContainer">
                        <label for="confirmpassword">Confirm Password</label><br />
                        <input type="password" name="confirmpassword" id="confirmpassword" />
                        <span class="error" id="confirmpasswordError"></span>
                    </div>
                    <div class="btn-Container">
                        <button type="submit">Create Account</button>
                    </div>
                </form>
            </div>

        </div>
    </div>

    <!-- feather icons -->
    <script>
        feather.replace();
    </script>

    <!-- Javascript -->
    <script src="{{ asset('js/register.js') }}"></script>
    <script>
        window.apiData = {

        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
