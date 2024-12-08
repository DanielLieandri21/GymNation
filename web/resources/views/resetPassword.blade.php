<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Reset Password</title>
    <link rel="stylesheet" href="{{ asset('css/resetPassword.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />
</head>

<body>
    {{-- CONTENT --}}
    <div class="main">
        <div class="login">
            <div class="img">
                <img class="GymnationLogo" src="{{ asset('assets/icon-appbar.png') }}" alt="Gymnation Logo" />

            </div>
            <div class="errorMassage" id="errMassage">
                <div class="massage">
                    <p>Your password reset link is not valid, or already used.</p>
                </div>
            </div>
            <div class="linkTO" id="linkToLoginpage">
                <a href="/admin">kembali ke login page</a>
            </div>
            <div class="input" id="inputContainer">
                <div class="container">
                    <form action="" method="POST" class="container">
                        @csrf
                        <div class="inputMail">
                            <label for="password">new password</label>
                            <input type="password" id="newPassword" name="password"
                                class="@error('password') is-invalid @enderror" required>
                        </div>
                        <div class="inputPass">
                            <label for="password">confirm Password</label>
                            <input type="password" id="confirmPass" name="password"
                                class="@error('password') is-invalid @enderror" required>
                        </div>
                        <div class="btn">
                            <button type="submit" id="resetPasswordBtn">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Javascript -->
    <script src="{{ asset('js/resetPassword.js') }}"></script>
    <script>
        window.apiData = {
            token: @json($token),
            userData: @json($userData)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
