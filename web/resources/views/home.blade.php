<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Gymnation</title>

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:ital,wght@0,100;0,300;0,400;0,700;0,&display=swap"
        rel="stylesheet" />

    <!-- feather icons -->
    <script src="https://unpkg.com/feather-icons"></script>

    <!-- My Styke -->
    <link rel="stylesheet" href="{{ asset('css/home.css') }}" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11/dist/sweetalert2.min.css" />
</head>

<body>
    <!-- Navbar Start -->
    <nav class="navbar">
        <a href="#" class="navbar-logo">
            <img src="{{ asset('assets/icon-appbar.png') }}" alt="Gymnation Logo" />
        </a>
        <div class="navbar-nav">
            <a href="#home">Home</a>
            <a href="#about">Our Program</a>
            <a href="#class">Our Class</a>
            <a href="#contact">Contact</a>
            <a href="/registerPage">
                <button class="btn-resgist">Register</button>
            </a>
        </div>
        <div class="navbar-extra">
            {{-- <a href="#" id="search"><i data-feather="search"></i></a> --}}
            <a href="#" id="hamburger-menu"><i data-feather="menu"></i></a>
        </div>
    </nav>
    <!-- Navbar End -->

    {{-- CAROUSEL --}}
    <div class="carouselContainer" id="home">
        <section class="carousel">
            <div class="carousel-wrapper" id="carouselWrapper">
                <!-- Slides will be injected here -->
            </div>
            <div class="carousel-controls">
                <span class="prev">&lt;</span>
                <span class="next">&gt;</span>
            </div>
        </section>

    </div>


    <!-- Hero Section -->
    <section class="hero top" style="background-image: url({{ asset('assets/background.png') }})">
        <main class="content">
            <h1>GYM<span>NATION</span></h1>
            <p>
                Fitness Center dengan konsep "GREEN" di Bandung yang mengutamakan
                latihan yang variatif serta fun. Dengan fasilitas alat terlengkap,
                terbaru & tertinggi di kelasnya. Gym Nation memiliki standar
                pengukuran wellness body analysis & movement screening untuk
                menganalisa postur tubuh serta identifikasi jenis gerakan yang sesuai.
            </p>
            <a href="/registerPage" class="cta">
                <button class="daftarsekarang">Daftar Sekarang</button>
            </a>
        </main>
    </section>
    <!-- Hero End -->

    <!-- About Section Start -->
    <section id="about" class="about">
        <h2><span>OUR</span> PROGRAM</h2>
        <div class="row">
            <div class="about-img">
                <img src="{{ asset('assets/food.jpg') }}" alt="Our Program" />
            </div>
            <div class="content">
                <h3>Weight Program</h3>
                <p>
                    Berat badan stuck disitu aja, mau turun susah atau bahkan susah naik
                    berat badan? Konsultasikan masalah & body goals mu bersama trainer
                    GymNation
                </p>
            </div>
        </div>
        <!-- section ke 2 -->
        <div class="row">
            <div class="content1">
                <h4>Body Building</h4>
                <p>
                    Ingin membentuk tubuh terutama otot, biar terlihat sixpack, bugar &
                    otot lebih berisi? Konsultasikan masalah & body goals mu bersama
                    trainer GymNation
                </p>
            </div>
            <div class="about1-img">
                <img src="{{ asset('assets/body-building.jpg') }}" alt="Our Program" />
            </div>
        </div>
        <!-- section ke 3 -->
        <div class="row">
            <div class="about2-img">
                <img src="{{ asset('assets/slim.jpg') }}" alt="Our Program" />
            </div>
            <div class="content2">
                <h5>Slim & Shape</h5>
                <p>
                    Ingin tampil sexy & punya badan kaya gitar Spanyol atau kaya idol
                    Korea? Konsultasikan masalah & body goals mu bersama trainer
                    GymNation
                </p>
            </div>
        </div>
    </section>
    <!-- About Section End -->

    <!-- menu section start -->
    <section id="class" class="class">
        <h2><span>OUR</span> CLASS</h2>
        <p>Pilih kelas favorite Nation Lovers</p>
        <div class="row">
            <div class="class-card">
                <img src="{{ asset('assets/boxing.jpg') }}" alt="Boxing" class="class-card-img" />
                <h6 class="class-card-title">- Hard Core Class -</h6>
                <p class="class-card-p">
                    Kelas Hard Core termasuk kelas dengan gerakan cepat & beban latihan
                    yang berat. Seperti : Trampoline, Spinnation, Zumba, Dance Art, TRX,
                    Muay Thai, Nation FreeStyle, Boxing Attack, Pump Nation, Step
                    Nation, Pound, S&C, dan lainnya.
                </p>
            </div>
            <div class="class-card">
                <img src="{{ asset('assets/yoga.jpg') }}" alt="Boxing" class="class-card-img" />
                <h6 class="class-card-title">- Body & Mind Class -</h6>
                <p class="class-card-p">
                    Kelas Body & Mind termasuk kelas dengan gerakan lambat & latihan
                    ringan yang berfokus pada peregangan tubuh serta menenangkan
                    pikiran. Seperti : Yoga, Aerial Yoga, Pilates dan lainnya.
                </p>
            </div>
            <div class="class-card">
                <img src="{{ asset('assets/dance.jpg') }}" alt="Boxing" class="class-card-img" />
                <h6 class="class-card-title">- Dance Class -</h6>
                <p class="class-card-p">
                    Kelas Dance merupakan kelas yang termasuk sedang & juga salah satu
                    pilihan ke 2 jika ingin latihan Cardio sedang, untuk Nation Lovers
                    yang suka dance atau ingin belajar dance bisa coba beberapa kelas
                    Dance yang ada di GymNation. Seperti : Hip Hop, Modern Dance, Belly
                    Dance, KPOPFIT, Line Dance, Cardio Dance, dan lainnya.
                </p>
            </div>
        </div>
    </section>
    <!-- menu section end -->

    <!-- Contact Section start-->
    <section id="contact" class="contact">
        <h2><span>OUR</span> CONTACT</h2>
        <p>Silahkan isi form dibawah untuk konsultasi membership</p>
        <div class="row">
            <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d504.6834806703691!2d107.60391708896945!3d-6.953349186570534!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x2e68e9b1a75a49d7%3A0xc4ef80b95e4a7b20!2sGymNation-Bdg!5e0!3m2!1sid!2sid!4v1728626045174!5m2!1sid!2sid"
                allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade" class="maps"></iframe>
            <form action="" onsubmit="addPengaduan(event)">
                @csrf
                <div class="input-group">
                    <i data-feather="user"></i>
                    <input type="text" placeholder="Nama" id="namaPengaduan" required />
                </div>
                <div class="input-group">
                    <i data-feather="mail"></i>
                    <input type="email" placeholder="Email" id="emailPengaduan" required />
                </div>
                <div class="input-group">
                    <i data-feather="phone"></i>
                    <input type="tel" placeholder="No HP" id="noHpPengaduan" required />
                </div>
                <div class="input-group">
                    <i data-feather="message-square"></i>
                    <textarea name="" id="pesanPengaduan" cols="30" rows="10" required></textarea>
                </div>
                <button type="submit" class="btn">Kirim Pesan</button>
            </form>
        </div>
    </section>
    <!-- Contact Section end-->

    <!-- footer start-->
    <footer>
        <div class="sosials">
            <a
                href="https://www.instagram.com/gymnation.bandung?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw=="><i
                    data-feather="instagram"></i></a>
            <a href="#"><i data-feather="twitter"></i></a>
            <a href="#"><i data-feather="facebook"></i></a>
        </div>

        <div class="links">
            <a href="#home">Home</a>
            <a href="#about">Our Program</a>
            <a href="#class">Our Class</a>
            <a href="#contact">Contact</a>
        </div>

        <div class="credit">
            <p>Created by <a href="">Daniel Lieandri</a>. | &copy; 2024.</p>
        </div>
    </footer>
    <!-- footer end-->

    <!-- feather icons -->
    <script>
        feather.replace();
    </script>
    <!-- Javascript -->
    <script src="{{ asset('js/home.js') }}"></script>
    <script>
        window.apiData = {
            DataCarousel: @json($dataCarousel)
        };
    </script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>

</html>
