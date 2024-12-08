document.addEventListener("DOMContentLoaded", function () {
    hamburger();
    createdAccount();
});

function hamburger() {
    const navbarNav = document.querySelector(".navbar-nav");
    const hamburgerMenu = document.querySelector("#hamburger-menu");

    if (navbarNav && hamburgerMenu) {
        hamburgerMenu.onclick = () => {
            navbarNav.classList.toggle("active");
        };
    }

    const hamburger = document.querySelector("#hamburger-menu");
    document.addEventListener("click", function (e) {
        if (!hamburger.contains(e.target) && !navbarNav.contains(e.target)) {
            navbarNav.classList.remove("active");
        }
    });
}

function createdAccount() {
    const registrationForm = document.getElementById("registrationForm");
    registrationForm.addEventListener("submit", async (event) => {
        event.preventDefault(); // Mencegah pengiriman form jika ada error

        let hasError = false;

        // Validasi First Name
        const firstName = document.getElementById("Fname");
        const firstNameError = document.getElementById("FnameError");
        if (firstName.value.trim() === "") {
            firstNameError.textContent = "First name is required.";
            firstNameError.style.display = "block";
            hasError = true;
        } else {
            firstNameError.textContent = "";
            firstNameError.style.display = "none";
        }

        // Validasi Last Name
        const lastName = document.getElementById("Lname");
        const lastNameError = document.getElementById("LnameError");
        if (lastName.value.trim() === "") {
            lastNameError.textContent = "Last name is required.";
            lastNameError.style.display = "block";
            hasError = true;
        } else {
            lastNameError.textContent = "";
            lastNameError.style.display = "none";
        }

        // Validasi Email
        const email = document.getElementById("email");
        const emailError = document.getElementById("emailError");
        if (email.value.trim() === "") {
            emailError.textContent = "Email is required.";
            emailError.style.display = "block";
            hasError = true;
        } else {
            emailError.textContent = "";
            emailError.style.display = "none";
        }

        // Validasi Password
        const password = document.getElementById("password");
        const passwordError = document.getElementById("passwordError");
        if (password.value.trim() === "") {
            passwordError.textContent = "Password is required.";
            passwordError.style.display = "block";
            hasError = true;
        } else {
            passwordError.textContent = "";
            passwordError.style.display = "none";
        }

        // Validasi Confirm Password
        const confirmPassword = document.getElementById("confirmpassword");
        const confirmPasswordError = document.getElementById(
            "confirmpasswordError"
        );
        if (confirmPassword.value.trim() === "") {
            confirmPasswordError.textContent = "Confirm password is required.";
            confirmPasswordError.style.display = "block";
            hasError = true;
        } else if (confirmPassword.value !== password.value) {
            confirmPasswordError.textContent = "Passwords do not match.";
            confirmPasswordError.style.display = "block";
            hasError = true;
        } else {
            confirmPasswordError.textContent = "";
            confirmPasswordError.style.display = "none";
        }

        if (!hasError) {
            const first_name = firstName.value;
            const last_name = lastName.value;
            const emailInput = email.value;
            const passwordInput = password.value;

            const formData = new FormData();
            formData.append("first_name", first_name);
            formData.append("last_name", last_name);
            formData.append("email", emailInput);
            formData.append("password", passwordInput);

            try {
                const response = await fetch("/createAccount", {
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
                        title: "Success!",
                        text: "Akun anda berhasil dibuat",
                        icon: "success",
                        confirmButtonText: "Lanjutkan",
                    }).then(() => {
                        window.location.href = "/";
                    });
                } else {
                    Swal.fire({
                        title: "Error!",
                        text: result.error || "Gagal membuat akun",
                        icon: "error",
                        confirmButtonText: "Coba Lagi",
                    });
                }
            } catch (error) {
                console.error("Error ketika membuat akun:", error);
                Swal.fire({
                    title: "Error!",
                    text: error || "Terjadi kesalahan saat membuat akun",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        }
    });
}
