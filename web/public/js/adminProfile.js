document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    loadProfile(data);
    updateProfile();
});

function loadProfile(data) {
    const Fname = document.getElementById("Fname");
    const Lname = document.getElementById("Lname");
    const Email = document.getElementById("email");
    const role = document.getElementById("role");

    Fname.value = `${data.userFound.data[0][0].first_name}`;
    Lname.value = `${data.userFound.data[0][0].last_name}`;
    Email.value = `${data.userFound.data[0][0].email}`;
    role.value = `${data.userFound.data[0][0].role}`;

    document.getElementById("updateFname").value = Fname.value;
    document.getElementById("updateLname").value = Lname.value;
    document.getElementById("updateEmail").value = Email.value;
}

function updateProfile() {
    const editAccountBtn = document.getElementById("editAccountBtn");
    const modal = document.getElementById("modal");
    const closeBtn = document.querySelector(".close");
    const userForm = document.getElementById("userForm");
    const registrationForm = document.getElementById("registrationForm");

    // Ambil nilai lama dari data
    const oldData = window.apiData.userFound.data[0][0];
    const id_user = oldData.id_user;
    const oldFname = oldData.first_name;
    const oldLname = oldData.last_name;
    const oldEmail = oldData.email;

    registrationForm.addEventListener("submit", (e) => {
        if (e.submitter && e.submitter.id === "editAccountBtn") {
            e.preventDefault();
        }
    });

    editAccountBtn.onclick = function (e) {
        modal.style.display = "block";
    };

    closeBtn.onclick = function () {
        modal.style.display = "none";
    };

    window.onclick = function (e) {
        if (e.target == modal) {
            modal.style.display = "none";
        }
    };

    userForm.onsubmit = async function (e) {
        e.preventDefault();

        // Ambil nilai baru dari form
        const newFname = document.getElementById("updateFname").value;
        const newLname = document.getElementById("updateLname").value;
        const newEmail = document.getElementById("updateEmail").value;

        if (
            newFname === oldFname &&
            newLname === oldLname &&
            newEmail === oldEmail
        ) {
            const RS = {
                newFname,
                newLname,
                newEmail,
            };
            console.log(RS);
            Swal.fire({
                title: "Error!",
                text: "Profile anda adalah profile terbaru",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        } else {
            const formData = new FormData();
            formData.append("id_user", id_user);
            formData.append("first_name", newFname);
            formData.append("last_name", newLname);
            formData.append("email", newEmail);

            try {
                const response = await fetch("/admin/editProfile", {
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
                        text: `Berhasil mengupdate profile`,
                        icon: "success",
                        confirmButtonText: "lanjutkan",
                    });
                    document.getElementById("modal").style.display = "none";
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: result.error || "Gagal mengupdate profile",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            } catch (error) {
                console.error("Error ketika mengupdate profile:", error);
                Swal.fire({
                    title: "Error!",
                    text: error || "Terjadi kesalahan saat mengupdate profile",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        }
    };
}

function logout() {
    Swal.fire({
        title: 'Apakah Anda yakin?',
        text: "Anda akan keluar dari sesi ini.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        cancelButtonText: 'Tidak',
        confirmButtonText: 'Iya, logout',
    }).then((result) => {
        if (result.isConfirmed) {
            fetch('/logout', {
                method: 'POST',
                credentials: 'include',
                headers: {
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content,
                    'Accept': 'application/json'
                }
            })
            .then(response => {
                if (response.ok) {
                    window.location.href = '/admin';
                } else {
                    Swal.fire({
                        title: 'Gagal Logout',
                        text: 'Terjadi masalah saat logout. Silakan coba lagi.',
                        icon: 'error'
                    });
                }
            })
            .catch(error => {
                console.error('Logout error:', error);
                Swal.fire({
                    title: 'Error',
                    text: 'Terjadi kesalahan jaringan. Silakan coba lagi.',
                    icon: 'error'
                });
            });
        }
    });
}
