document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    loadUser(data);
    addUser();
});

function loadUser(data) {
    const tbody = $("#carouselTable tbody");
    tbody.empty();

    if (!data.dataUser.data || data.dataUser.data.length === 0) {
        tbody.append(
            `<tr>
                <td colspan="4" style="text-align: center;">Data Not Found</td>
            </tr>`
        );
    } else {
        data.dataUser.data.forEach((user, index) => {
            const row = `
                    <tr>
                        <td>${index + 1}</td>
                        <td>${user.first_name} ${user.last_name}</td>
                        <td>${user.email}</td>
                        <td>${user.role}</td>
                        <td>
                            <button class="action-btn delete-btn" data-id="${
                                user.id_user
                            }" data-name="${user.first_name} ${
                user.last_name
            }">Delete</button>
                        </td>
                    </tr>
                `;

            tbody.append(row);
        });

        $(".delete-btn").on("click", function () {
            const userId = $(this).data("id");
            const name = $(this).data("name");
            deleteUser(userId, name);
        });
    }
}

function deleteUser(idUser, nama) {
    const confirmDelete = confirm(
        `Apakah kamu ingin menghapus akun: ${nama} ?`
    );

    if (confirmDelete) {
        fetch("/admin/deleteUser", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json",
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: JSON.stringify({ id_user: idUser }),
        })
            .then((response) => {
                if (!response.ok) {
                    throw new Error("Gagal menghapus akun user.");
                }
                return response.json();
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        title: "success!",
                        text: `Berhasil menghapus akun ${nama}`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: data.error || "Gagal menghapus akun user",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            })
            .catch((error) => {
                console.error("Error ketika menghapus akun:", error);
                Swal.fire({
                    title: "Error!",
                    text: "Terjadi kesalahan saat menghapus akun",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            });
    }
}

function addUser() {
    const tambahBtn = document.getElementById("tambahBtn");
    const modal = document.getElementById("modal");
    const closeBtn = document.querySelector(".close");
    const userForm = document.getElementById("userForm");

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

    userForm.addEventListener("submit", async (event) => {
        event.preventDefault();

        const first_name = document.getElementById("first_name").value;
        const last_name = document.getElementById("last_name").value;
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirm_password").value;
        const role = document.getElementById("role").value;
        const passwordError = document.getElementById("passwordError");
        
        if (password !== confirmPassword) {
            passwordError.style.display = "block";
        } else {
            passwordError.style.display = "none";
        }

        if (!first_name || !last_name || !email || !password || !confirmPassword || !role) {
            alert("Harap lengkapi semua input.");
            return;
        }

        const formData = new FormData();
        formData.append("first_name", first_name);
        formData.append("last_name", last_name);
        formData.append("email", email);
        formData.append("password", password);
        formData.append("role", role);

        try {
            const response = await fetch("/admin/tambahUser", {
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
                    text: `Berhasil menambahkan user`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
                document.getElementById("modal").style.display = "none";
            } else {
                Swal.fire({
                    title: "Error!",
                    text: result.error ||"Gagal menambahkan user",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        } catch (error) {
            console.error("Error ketika menambahkan user:", error);
            Swal.fire({
                title: "Error!",
                text: error||"Terjadi kesalahan saat menambahkan user",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }

    });
}

