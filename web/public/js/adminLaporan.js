document.addEventListener("DOMContentLoaded", function () {
    const data  = window.apiData;
    loadDataCarousel(data)
})

function loadDataCarousel(data){
    const tbody = $("#carouselTable tbody");
    tbody.empty();

    if (!data.dataPengaduan.data || data.dataPengaduan.data.length ===0) {
        tbody.append(
            `<tr>
                <td colspan="4" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    }else{
        data.dataPengaduan.data.forEach((pengaduan, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${pengaduan.nama}</td>
                        <td>${pengaduan.email}</td>
                        <td>${pengaduan.no_telpon}</td>
                        <td>${pengaduan.pesan}</td>
                        <td>
                            <button class="action-btn delete-btn" data-id="${
                                pengaduan.id_pengaduan
                            }" data-name="${pengaduan.nama}">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-btn").on("click", function () {
            const id_pengaduan = $(this).data("id");
            const nama = $(this).data("name");
            deletePengaduan(id_pengaduan, nama);
        });
    }
}

function deletePengaduan(id_pengaduan, nama){
    const confirmDelete = confirm(`Apakah kamu ingin mengedit pengaduan: ${nama} ?`);
    if (confirmDelete) {
        fetch("/admin/deleteLaporan", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_Pengaduan: id_pengaduan }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus pengaduan.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus pengaduan ${nama}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus pengaduan",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus pengaduan:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus pengaduan",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}
