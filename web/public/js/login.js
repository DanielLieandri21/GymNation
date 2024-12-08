document.addEventListener("DOMContentLoaded", function () {
    popup();
});

function popup() {
    const tambahBtn = document.getElementById("lupaPasswordButton");
    const modal = document.getElementById("modal");
    const closeBtn = document.querySelector(".close");
    const carouselForm = document.getElementById("carouselForm");
    const submitBtn = document.getElementById("submitBtn");

    tambahBtn.addEventListener("click", () => {
        event.preventDefault();
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
    
    submitBtn.addEventListener("click", (event) => {
        event.preventDefault(); 
        requestResetPassword();
        // startCountdown();
    });
}

function startCountdown() {
    let countdownInterval;
    let timeLeft = 60; 
    submitBtn.disabled = true; 
    countdownMessage.textContent = `Tunggu ${timeLeft} detik untuk mengirim ulang.`;

    countdownInterval = setInterval(() => {
        timeLeft--;
        countdownMessage.textContent = `Tunggu ${timeLeft} detik untuk mengirim ulang.`;

        if (timeLeft <= 0) {
            clearInterval(countdownInterval);
            countdownMessage.textContent = ""; 
            submitBtn.disabled = false; 
        }
    }, 1000);
}

function requestResetPassword(){
    const email = document.getElementById("email").value;

    fetch("/requestResetPassword", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
            "X-CSRF-TOKEN": document.querySelector(
                'meta[name="csrf-token"]'
            ).content,
        },
        body: JSON.stringify({email: email}),
    }).then((response) => {
        if (!response.ok) {
            throw new Error("Gagal mengirimkan permintaan.");
        }
        return response.json();
    }).then((data) => {
        if (data.success) {
            Swal.fire({
                title: "success!",
                text: `Silahkan cek email anda`,
                icon: "success",
                confirmButtonText: "lanjutkan",
            });
            startCountdown();
        } else {
            Swal.fire({
                title: "Error!",
                text: data.error || "Gagal mengirimkan permintaan",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    })
    .catch((error) => {
        console.error("Error ketika mengirimkan permintaan:", error);
        Swal.fire({
            title: "Error!",
            text: "Terjadi kesalahan saat mengirimkan permintaan",
            icon: "error",
            confirmButtonText: "Coba Lagi",
        });
    });
}
