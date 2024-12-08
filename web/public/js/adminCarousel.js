document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    loadDataCarousel(data);
    popUp();
});

function loadDataCarousel(data) {
    const tbody = $("#carouselTable tbody");
    tbody.empty();

    if (!data.DataCarousel.data || data.DataCarousel.data.length === 0) {
        tbody.append(
            `<tr>
                <td colspan="4" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.DataCarousel.data.forEach((carousel, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>
                            <img src="${carousel.img_path}" alt="${
                carousel.title
            }">
                        </td>
                        <td>${carousel.title}</td>
                        <td>
                            <button class="action-btn delete-btn" data-id="${
                                carousel.id_carousel
                            }" data-name="${carousel.title}">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-btn").on("click", function () {
            const userId = $(this).data("id");
            const name = $(this).data("name");
            deleteCarousel(userId, name);
        });
    }
}

function deleteCarousel(idCarousel, title) {
    const confirmDelete = confirm(
        `Apakah kamu ingin mengedit carousel: ${title} ?`
    );
    if (confirmDelete) {
        fetch("/admin/deleteCarousel", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_carousel: idCarousel }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus carousel.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus carousel ${title}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus carousel",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus carousel:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus carousel",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function popUp() {
    const tambahBtn = document.getElementById("tambahBtn");
    const modal = document.getElementById("modal");
    const closeBtn = document.querySelector(".close");
    const carouselForm = document.getElementById("carouselForm");

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

    carouselForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const title = document.getElementById("title").value;
        const carousel_img = document.getElementById("carousel_img").files[0];
        if (!title || !carousel_img) {
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("title", title);
        formData.append("carousel_img", carousel_img);

        try {
            const response = await fetch("/admin/addCarousel", {
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
                    text: `Berhasil menambahkan carousel`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("modal").style.display = "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error ||"Gagal menambahkan carousel",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan carousel:", error);
            Swal.fire({
                title: "Error!",
                text: error||"Terjadi kesalahan saat menambahkan carousel",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    });
}
