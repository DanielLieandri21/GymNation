document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    console.log(data)
    displayStatusGYM(data.statusGYM.data[0].status);

    const submitButton = document.getElementById("submitBtn");
    submitButton.addEventListener("click", updateStatus);
});

function displayStatusGYM(status) {
    const statusCircle = document.querySelector(".status-circle");
    const statusText = document.querySelector(".status-text");

    if (status === "open") {
        statusCircle.classList.remove("closed");
        statusCircle.classList.add("open");
        statusText.textContent = "Gym Open";
    } else if (status === "closed") {
        statusCircle.classList.remove("open");
        statusCircle.classList.add("closed");
        statusText.textContent = "Gym Closed";
    } else {
        statusCircle.classList.remove("open");
        statusCircle.classList.add("undifined");
        statusText.textContent = "status undifined";
    }
}

async function updateStatus() {
    const statusDropdown = document.getElementById("statusDropdown");
    const selectedStatus = statusDropdown.value;

    const formData = new FormData();
    formData.append("status", selectedStatus);
    try {
        const response = await fetch("/admin/editStatusGYM", {
            method: "POST",
            headers: {
                "X-CSRF-TOKEN": document.querySelector(
                    'meta[name="csrf-token"]'
                ).content,
            },
            body: formData,
        });

        const result = await response.json();
        if (result.success) {
            Swal.fire({
                title: "success!",
                text: `Berhasil mengedit status GYM`,
                icon: "success",
                confirmButtonText: "lanjutkan",
            });
        } else {
            console.log(result.error)
            Swal.fire({
                title: "Error!",
                text: result.error || "Gagal Berhasil mengedit status GYM",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        }
    } catch (error) {
        console.error("Error ketika mengedit status gym:", error);
        Swal.fire({
            title: "Error!",
            text: error || "Terjadi kesalahan saat status gym",
            icon: "error",
            confirmButtonText: "Coba Lagi",
        });
    }
}
