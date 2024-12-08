document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    loadDataFasilitas(data);
    loadDataMakanan(data);
    loadDataKelas(data);
    loadDataPotonganHarga(data)
    popUpTambahFasilitas();
    popUpTambahMakanan();
    popUpTambahKelas();
    popUpTambahPotonganHarga();
});

// DATA FASILITAS
function loadDataFasilitas(data) {
    const tbody = $("#fasilitasTable tbody");
    tbody.empty();

    if (!data.dataFasilitas.data || data.dataFasilitas.data === 0) {
        tbody.append(
            `<tr>
                <td colspan="4" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.dataFasilitas.data.forEach((fasilitas, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>
                            <img src="${fasilitas.img_path}" alt="${
                fasilitas.title
            }">
                        </td>
                        <td>${fasilitas.title}</td>
                        <td>
                            <button class="delete-dataFasilitas-btn" data-id="${
                                fasilitas.id_fasilitas
                            }" data-name="${fasilitas.title}">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-dataFasilitas-btn").on("click", function () {
            const userId = $(this).data("id");
            const name = $(this).data("name");
            deleteFasilitas(userId, name);
        });
    }
}

function deleteFasilitas(id_fasilitas, title) {
    const confirmDelete = confirm(
        `Apakah kamu ingin menghapus fasilitas: ${title} ?`
    );
    if (confirmDelete) {
        fetch("/admin/deleteFasilitas", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_fasilitas: id_fasilitas }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus fasilitas.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus fasilitas ${title}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus fasilitas",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus fasilitas:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus fasilitas",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function popUpTambahFasilitas() {
    const tambahBtn = document.getElementById("tambahFasilitasBtn");
    const modal = document.getElementById("tambahFasilitasModal");
    const closeBtn = document.getElementById("closeTambahFasilitas");
    const tambahFasilitasForm = document.getElementById("tambahFasilitasForm");

    tambahBtn.addEventListener("click", () => {
        modal.style.display = "block";
    });

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    tambahFasilitasForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const title = document.getElementById("titleFasilitas").value;
        const fasilitas_img = document.getElementById("fasilitas_img").files[0];
        if (!title || !fasilitas_img) {
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("title", title);
        formData.append("fasilitas_img", fasilitas_img);

        try {
            const response = await fetch("/admin/addFasilitas", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil menambahkan fasilitas`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("tambahFasilitasModal").style.display =
                    "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal menambahkan fasilitas",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan fasilitas:", error);
            Swal.fire({
                title: "Error!",
                text: error || "Terjadi kesalahan saat menambahkan fasilitas",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}

// DATA MAKANAN
function loadDataMakanan(data) {
    const tbody = $("#makananSehatTable tbody");
    tbody.empty();

    if (!data.dataMakanan.data || data.dataMakanan.data === 0) {
        tbody.append(
            `<tr>
                <td colspan="5" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.dataMakanan.data.forEach((makanan, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>
                            <img src="${makanan.img_path}" alt="${
                makanan.title
            }">
                        </td>
                        <td>${makanan.title}</td>
                        <td>${makanan.deskripsi}</td>
                        <td>
                            <button class="delete-dataMakanan-btn" data-id="${
                                makanan.id_makanan
                            }" data-name="${makanan.title}">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-dataMakanan-btn").on("click", function () {

            const userId = $(this).data("id");
            const name = $(this).data("name");
            console.log(name)
            deleteMakanan(userId, name);
        });
    }
}

function deleteMakanan(id_makanan, title) {
    const confirmDelete = confirm(
        `Apakah kamu ingin menghapus makanan: ${title} ?`
    );
    if (confirmDelete) {
        fetch("/admin/deleteMakanan", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_makanan: id_makanan }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus makanan.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus makanan ${title}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus makanan",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus makanan:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus makanan",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function popUpTambahMakanan() {
    const tambahBtn = document.getElementById("makananSehatBtn");
    const modal = document.getElementById("tambahMakananModal");
    const closeBtn = document.getElementById("closeTambahMakanan");
    const tambahMakananForm = document.getElementById("tambahMakananForm");

    tambahBtn.addEventListener("click", () => {
        modal.style.display = "block";
    });

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    tambahMakananForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const title = document.getElementById("titleMakananInput").value;
        const makanan_img =
            document.getElementById("imageMakananInput").files[0];
        const desc = document.getElementById("descriptionMakananInput").value;

        if (!title || !makanan_img || !desc) {
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("title", title);
        formData.append("deskripsi", desc);
        formData.append("makanansehat_img", makanan_img);

        try {
            const response = await fetch("/admin/addMakanan", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil menambahkan makanan`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("tambahMakananModal").style.display =
                    "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal menambahkan makanan",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan makanan:", error);
            Swal.fire({
                title: "Error!",
                text: error || "Terjadi kesalahan saat menambahkan makanan",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}

// DATA KELAS
function loadDataKelas(data) {
    const tbody = $("#kelasTable tbody");
    tbody.empty();

    if (!data.dataKelas.data || data.dataKelas.data === 0) {
        tbody.append(
            `<tr>
                <td colspan="6" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.dataKelas.data.forEach((kelas, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${kelas.nama_kelas}</td>
                        <td>${kelas.jadwal}</td>
                        <td>
                            <div class="jumlahAnggotaKelas">
                                ${kelas.jumlah_anggota}
                                <button class="edit-dataKelas-jumlahAnggota-btn" data-id="${
                                    kelas.id_kelas
                                }" data-jumlahanggota="${
                kelas.jumlah_anggota
            }">+</button>
                            </div>
                        </td>
                        <td>${kelas.pelatih}</td>
                        <td>
                            <button class="delete-dataKelas-btn" data-id="${
                                kelas.id_kelas
                            }" data-name="${kelas.nama_kelas}">Delete</button>
                            <button class="edit-dataKelas-jadwal-btn" data-id="${
                                kelas.id_kelas
                            }" data-jadwal="${
                kelas.jadwal
            }">edit jadwal</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-dataKelas-btn").on("click", function () {
            const userId = $(this).data("id");
            const name = $(this).data("name");
            deleteKelas(userId, name);
        });

        $(".edit-dataKelas-jumlahAnggota-btn").on("click", function () {
            const userId = $(this).data("id");
            const jumlahAnggota = $(this).data("jumlahanggota");
            modalTambahAnggota(userId, jumlahAnggota);
        });

        $(".edit-dataKelas-jadwal-btn").on("click", function () {
            const userId = $(this).data("id");
            const jadwal = $(this).data("jadwal");
            modalEditHari(userId, jadwal);
        });
    }
}

function deleteKelas(id_kelas, nama_kelas) {
    const confirmDelete = confirm(
        `Apakah kamu ingin menghapus kelas: ${nama_kelas} ?`
    );
    if (confirmDelete) {
        fetch("/admin/deleteKelas", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_kelas: id_kelas }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus kelas.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus kelas ${nama_kelas}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus kelas",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus kelas:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus kelas",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function modalTambahAnggota(id_kelas, jumlahAnggota) {
    const modal = document.getElementById("modalEditJumlahAnggota");
    const closeBtn = document.getElementById("closeEditJumlahAnggota");
    const formEditJumlahAnggota = document.getElementById(
        "formEditJumlahAnggota"
    );
    const currentJumlahAnggota = document.getElementById(
        "currentJumlahAnggota"
    );
    currentJumlahAnggota.value = `${jumlahAnggota}`;

    modal.style.display = "block";

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    formEditJumlahAnggota.addEventListener("submit", async (event) => {
        event.preventDefault();

        const newJumlahAnggota =
            document.getElementById("newJumlahAnggota").value;
        if (!newJumlahAnggota) {
            alert("Masukan jumlah anggota");
            return;
        }

        const formData = new FormData();
        formData.append("id_kelas", id_kelas);
        formData.append("jumlah_anggota", newJumlahAnggota);

        try {
            const response = await fetch("/admin/editAnggotaKelas", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil mengedit jumlah anggota kelas`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById(
                    "modalEditJumlahAnggota"
                ).style.display = "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal mengedit jumlah anggota kelas",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika mengedit jumlah anggota kelas:", error);
            Swal.fire({
                title: "Error!",
                text:
                    error ||
                    "Terjadi kesalahan saatmengedit jumlah anggota kelas",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}

function modalEditHari(id_kelas, jadwal) {
    const modal = document.getElementById("modalEditJadwal");
    const closeBtn = document.getElementById("closeEditJadwal");
    const formEditJadwal = document.getElementById("formEditJadwal");
    const currentJadwal = document.getElementById("currentJadwal");

    currentJadwal.value = `${jadwal}`;
    modal.style.display = "block";

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    formEditJadwal.addEventListener("submit", async (event) => {
        event.preventDefault();

        const newJadwal = document.getElementById("newJadwal").value;
        if (!newJadwal) {
            alert("Masukan Jadwal Terbaru");
            return;
        }

        const formData = new FormData();
        formData.append("id_kelas", id_kelas);
        formData.append("hari", newJadwal);

        try {
            const response = await fetch("/admin/editHariKelas", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil mengedit hari`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById(
                    "modalEditJadwal"
                ).style.display = "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal mengedit hari",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika mengedit hari:", error);
            Swal.fire({
                title: "Error!",
                text:
                    error ||
                    "Terjadi kesalahan saatmengedit hari",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}

function popUpTambahKelas() {
    const tambahBtn = document.getElementById("kelasBtn");
    const modal = document.getElementById("modalAddKelas");
    const closeBtn = document.getElementById("closeAddKelas");
    const formAddKelas = document.getElementById("formAddKelas");

    tambahBtn.addEventListener("click", () => {
        modal.style.display = "block";
    });

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    formAddKelas.addEventListener("submit", async (event) => {
        event.preventDefault();

        const title = document.getElementById("addNamaKelas").value;
        const jadwal = document.getElementById("addJadwal").value;
        const jumlah_anggota = document.getElementById("addJumlahAnggota").value;
        const newNamaPelatih = document.getElementById("addNamaPelatih").value;

        if (!title || !jadwal  || !newNamaPelatih) {
            console.log(title, jadwal, newNamaPelatih)
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("nama_kelas", title);
        formData.append("jadwal", jadwal);
        formData.append("jumlah_anggota", jumlah_anggota);
        formData.append("pelatih", newNamaPelatih);

        try {
            const response = await fetch("/admin/addKelas", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil menambahkan Kelas`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("modalAddKelas").style.display =
                    "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal menambahkan Kelas",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan Kelas:", error);
            Swal.fire({
                title: "Error!",
                text: error || "Terjadi kesalahan saat menambahkan Kelas",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}

// DATA POTONGAN HARGA
function loadDataPotonganHarga(data) {
    const tbody = $("#potonganHargaTable tbody");
    tbody.empty();

    if (!data.dataPotonganHarga.data || data.dataPotonganHarga.data === 0) {
        tbody.append(
            `<tr>
                <td colspan="5" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.dataPotonganHarga.data.forEach((potongan, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${potongan.title}</td>
                        <td>${potongan.jumlah_diskon} %</td>
                        <td>
                            <button class="delete-potongan-btn" data-id="${
                                potongan.id_potongan_harga
                            }" data-name="${potongan.title}">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-potongan-btn").on("click", function () {
            const userId = $(this).data("id");
            const name = $(this).data("name");
            deletePotonganHarga(userId, name);
        });
    }
}

function deletePotonganHarga(id_potongan_harga, title) {
    const confirmDelete = confirm(
        `Apakah kamu ingin menghapus potongan harga: ${title} ?`
    );
    if (confirmDelete) {
        fetch("/admin/deletePotonganHarga", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_potongan_harga: id_potongan_harga }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus potongan harga.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus potongan harga ${title}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus potongan harga",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus potongan harga:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus potongan harga",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function popUpTambahPotonganHarga() {
    const tambahBtn = document.getElementById("potonganHargaBtn");
    const modal = document.getElementById("modalTambahPotonganHarga");
    const closeBtn = document.getElementById("closeTambahPotonganHarga");
    const formTambahPotonganHarga = document.getElementById("formTambahPotonganHarga");

    tambahBtn.addEventListener("click", () => {
        modal.style.display = "block";
    });

    closeBtn.addEventListener("click", () => {
        modal.style.display = "none";
    });

    window.addEventListener("click", (event) => {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });

    formTambahPotonganHarga.addEventListener("submit", async (event) => {
        event.preventDefault();

        const title = document.getElementById("addTitlePotonganHarga").value;
        const newJumlahPotonganHarga = document.getElementById("newJumlahPotonganHarga").value;
        if (!title || !newJumlahPotonganHarga) {
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("title", title);
        formData.append("jumlah_diskon", newJumlahPotonganHarga);

        try {
            const response = await fetch("/admin/addPotonganHarga", {
                method: "POST",
                body: formData,
                headers: {
                    "X-CSRF-TOKEN": document.querySelector(
                        'meta[name="csrf-token"]'
                    ).content,
                },
            });
            const result = await response.json();
            if (result.success) {
                Swal.fire({
                    title: "success!",
                    text: `Berhasil menambahkan potongan harga`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("modalTambahPotonganHarga").style.display =
                    "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error || "Gagal menambahkan potongan harga",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan potongan harga:", error);
            Swal.fire({
                title: "Error!",
                text: error || "Terjadi kesalahan saat menambahkan potongan harga",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}