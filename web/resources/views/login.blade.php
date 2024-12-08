<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Login Page</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,300;0,400;0,700;0,&display=swap"
        rel="stylesheet" />

    <!-- My Styke -->
    <link rel="stylesheet" href="{{ asset('css/login.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />

</head>

<body>
    <div class="main">
        <div class="login">
            <img class="GymnationLogo" src="{{ asset('assets/icon-appbar.png') }}" alt="Gymnation Logo" />
            <div class="input">
                <div class="container">
                    <form action="{{ route('login.process') }}" method="POST" class="container">
                        @csrf

                        <div class="inputMail">
                            <label for="email">Email</label>
                            <input type="email" name="email" class="@error('email') is-invalid @enderror" required>
                            @error('email')
                                <div class="error-message">{{ $message }}</div>
                            @enderror
                        </div>
                        <div class="inputPass">
                            <label for="password">Password</label>
                            <input type="password" name="password" class="@error('password') is-invalid @enderror"
                                required>
                            @error('password')
                                <div class="error-message">{{ $message }}</div>
                            @enderror
                            <div class="lupaPassword">
                                <a href="" id="lupaPasswordButton">
                                    lupa password
                                </a>
                            </div>
                        </div>
                        @if ($errors->has('login'))
                            <div class="error-message">{{ $errors->first('login') }}</div>
                        @endif
                        <div class="btn">
                            <button type="submit">login</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Pop-up -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Silahkan Masukan Email Anda</h2>
            <form id="carouselForm">
                <div class="emailInput">
                    <label for="email">Email</label><br>
                    <input type="email" id="email" name="email" required>
                </div>
                <br><br>
                <div class="btn-submit">
                    <button type="submit" id="submitBtn">submit</button>
                </div>
                <p id="countdownMessage"></p>
            </form>
        </div>
    </div>
    <script src="{{ asset('js/login.js') }}"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

</body>

</html>
