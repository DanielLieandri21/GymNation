document.addEventListener("DOMContentLoaded", function () {
    const data = window.apiData;
    hamburger();
    carousel(data);
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

function carousel(data) {
    const carouselWrapper = document.getElementById("carouselWrapper");

    data.DataCarousel.data.forEach((item, index) => {
        const slide = document.createElement("div");
        slide.className = `carousel-slide ${index === 0 ? "active" : ""}`;
        slide.innerHTML = `
      <div class="containerCarousel">
        <img src="${item.img_path}" alt="${item.title}">
        <div>
        <p class="carousel-title">${item.title}</p>
      `;
        carouselWrapper.appendChild(slide);
    });

    const slides = document.querySelectorAll(".carousel-slide");
    const prevButton = document.querySelector(".carousel-controls .prev");
    const nextButton = document.querySelector(".carousel-controls .next");
    let currentSlide = 0;

    function showSlide(index) {
        slides.forEach((slide, i) => {
            slide.classList.remove("active");
            if (i === index) {
                slide.classList.add("active");
            }
        });
        carouselWrapper.style.transform = `translateX(-${index * 100}%)`;
    }

    prevButton.addEventListener("click", () => {
        currentSlide = (currentSlide - 1 + slides.length) % slides.length;
        showSlide(currentSlide);
    });

    nextButton.addEventListener("click", () => {
        currentSlide = (currentSlide + 1) % slides.length;
        showSlide(currentSlide);
    });

    setInterval(() => {
        currentSlide = (currentSlide + 1) % slides.length;
        showSlide(currentSlide);
    }, 5000);
}


async function addPengaduan(event){
  event.preventDefault();

  const nama = document.getElementById("namaPengaduan").value;
  const email = document.getElementById("emailPengaduan").value;
  const noTelp = document.getElementById("noHpPengaduan").value;
  const pesan = document.getElementById("pesanPengaduan").value;

  const confirmDelete = confirm(
    `Apakah kamu ingin mengirim pengaduan ?`
);
const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

if (confirmDelete) {
    await fetch("/addPengaduan", {
        method: "POST",
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-TOKEN': csrfToken, 
      },
        body: JSON.stringify({
          nama,
          email,
          no_telpon: noTelp,
          pesan,
      }),
    })
        .then((response) => {
            if (!response.ok) {
                throw new Error("gagal menambahkan pengaduan.");
            }
            return response.json();
        })
        .then((data) => {
            if (data.success) {
                Swal.fire({
                    title: "success!",
                    text: `pengaduan anda akan kami proses`,
                    icon: "success",
                    confirmButtonText: "lanjutkan",
                });
            } else {
                Swal.fire({
                    title: "Error!",
                    text: data.error || "Gagal menambahkan pengaduan",
                    icon: "error",
                    confirmButtonText: "Coba Lagi",
                });
            }
        })
        .catch((error) => {
            console.error("Error ketika menambahkan pengaduan:", error);
            Swal.fire({
                title: "Error!",
                text: "Terjadi kesalahan saat menambahkan pengaduan",
                icon: "error",
                confirmButtonText: "Coba Lagi",
            });
        });
}
}