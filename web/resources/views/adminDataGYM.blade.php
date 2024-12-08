<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>Data GYM</title>
    <link rel="stylesheet" href="{{ asset('css/adminDataGYM.css') }}" />
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
    <div class="pilihanData">
        <div class="containerData">
            <div class="fasilitas">
                <a href="#fasilitas" class="cta-link">
                    <button>Fasilitas</button>
                </a>
            </div>
            <div class="makananSehat">
                <a href="#makananSehat" class="cta-link">
                    <button>makanan sehat</button>
                </a>
            </div>
            <div class="kelas">
                <a href="#kelas" class="cta-link">
                    <button>kelas</button>
                </a>
            </div>
            <div class="potonganHarga">
                <a href="#potonganHarga" class="cta-link">
                    <button>potongan harga</button>
                </a>
            </div>
        </div>
    </div>

    {{-- table fasilitas --}}
    <div class="tableData" id="fasilitas">
        <h1>data fasilitas</h1>
        <table id="fasilitasTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>foto</th>
                    <th>jenis fasilitas</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="tambahFasilitas">
        <button id="tambahFasilitasBtn">Tambah Data User</button>
    </div>

    {{-- table makanan sehat --}}
    <div class="tableData" id="makananSehat">
        <h1>data makanan sehat</h1>
        <table id="makananSehatTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>foto</th>
                    <th>title</th>
                    <th>deskripsi</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="tambahMakananSehat">
        <button id="makananSehatBtn">Tambah makanan sehat</button>
    </div>
    
    {{-- table kelas --}}
    <div class="tableData" id="kelas">
        <h1>data kelas</h1>
        <table id="kelasTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>nama kelas</th>
                    <th>jadwal</th>
                    <th>jumlah anggota</th>
                    <th>pelatih</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="tambahKelas">
        <button id="kelasBtn">Tambah kelas</button>
    </div>
    
    {{-- table potongan harga --}}
    <div class="tableData" id="potonganHarga">
        <h1>data potongan harga</h1>
        <table id="potonganHargaTable">
            <thead>
                <tr>
                    <th>No</th>
                    <th>jenis potongan</th>
                    <th>jumlah potongan</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody></tbody>
        </table>
    </div>

    <div class="tambahPotonganHarga">
        <button id="potonganHargaBtn">Tambah Potongan Harga</button>
    </div>

    {{-- MODAL UNTUK MENAMBAHKAN FASILITAS --}}
    <div id="tambahFasilitasModal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeTambahFasilitas">&times;</span>
            <h2>Tambah Data Fasilitas</h2>
            <form id="tambahFasilitasForm">
                <label for="titleFasilitas">Nama:</label><br>
                <input type="text" id="titleFasilitas" name="titleFasilitas" required>
                <br><br>

                <label for="fasilitas_img">Foto:</label><br>
                <input type="file" id="fasilitas_img" name="fasilitas_img" accept="image/*" required>
                <br><br>

                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>
      
    {{-- MODAL UNTUK MENAMBAHKAN MAKANAN --}}
    <div id="tambahMakananModal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeTambahMakanan">&times;</span>
            <h2>Tambah Data</h2>
            <form id="tambahMakananForm">
                <label for="titleMakananInput">Judul:</label>
                <input type="text" id="titleMakananInput" name="titleMakananInput" required>
                <br><br>
                
                <label for="descriptionMakananInput">Deskripsi:</label>
                <br>
                <textarea id="descriptionMakananInput" name="descriptionMakananInput" rows="4" required></textarea>
                <br><br>
                
                <label for="imageMakananInput">Unggah Gambar:</label>
                <input type="file" id="imageMakananInput" name="imageMakananInput" accept="image/*" required>
                <br><br>
    
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>
    
    {{-- MODAL UNTUK EDIT JUMLAH ANGGOTA --}}
    <div id="modalEditJumlahAnggota" class="modal">
        <div class="modal-content">
            <span class="close" id="closeEditJumlahAnggota">&times;</span>
            <h2>Edit Jumlah Anggota</h2>
            <form id="formEditJumlahAnggota">
                <label for="currentJumlahAnggota">Jumlah Anggota Sekarang:</label>
                <input type="text" id="currentJumlahAnggota" readonly>
                <br><br>
                <label for="newJumlahAnggota">Jumlah Anggota Baru:</label>
                <input type="number" id="newJumlahAnggota" required>
                <br><br>
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>

    {{-- MODAL UNTUK EDIT JADWAL --}}
    <div id="modalEditJadwal" class="modal">
        <div class="modal-content">
            <span class="close" id="closeEditJadwal">&times;</span>
            <h2>Edit Jadwal</h2>
            <form id="formEditJadwal">
                <label for="currentJadwal">Jadwal Sekarang:</label>
                <input type="text" id="currentJadwal" readonly>
                <br><br>
                <label for="newJadwal">Jadwal Baru:</label>
                <input type="text" id="newJadwal" required>
                <br><br>
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>

    {{-- MODAL UNTUK MENAMBAHKAN KELAS --}}
    <div id="modalAddKelas" class="modal">
        <div class="modal-content">
            <span class="close" id="closeAddKelas">&times;</span>
            <h2>Tambah Kelas Baru</h2>
            <form id="formAddKelas">
                <label for="namaKelas">Nama Kelas:</label>
                <input type="text" id="addNamaKelas" required>
                <br><br>
                <label for="newJadwal">Jadwal Kelas:</label>
                <input type="text" id="addJadwal" required>
                <br><br>
                <label for="newJumlahAnggota">jumlah anggota:</label>
                <input type="number" id="addJumlahAnggota" required>
                <br><br>
                <label for="newNamaPelatih">Nama Pelatih:</label>
                <input type="text" id="addNamaPelatih" required>
                <br><br>
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>

    {{-- MODAL UNTUK TAMBAH POTONGAN HARGA --}}
    <div id="modalTambahPotonganHarga" class="modal">
        <div class="modal-content">
            <span class="close" id="closeTambahPotonganHarga">&times;</span>
            <h2>Tambah Potongan Harga</h2>
            <form id="formTambahPotonganHarga">
                <label for="addTitlePotonganHarga">Title:</label><br>
                <input type="text" id="addTitlePotonganHarga" >

                <br><br>
                <label for="newJumlahPotonganHarga">Jumlah potongan harga:</label><br>
                <input type="number" id="newJumlahPotonganHarga" required>
                
                <br><br>
                <button type="submit">Simpan</button>
            </form>
        </div>
    </div>
    
    
    <!-- Javascript -->
    <script>
        window.apiData = {
            dataFasilitas: @json($dataFasilitas),
            dataMakanan: @json($dataMakanan),
            dataKelas: @json($dataKelas),
            dataPotonganHarga: @json($dataPotonganHarga)
        };
        </script>
    <script src="{{ asset('js/adminDataGYM.js') }}"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</body>
</html>