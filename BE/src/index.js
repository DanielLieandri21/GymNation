require("dotenv").config();
const PORT = process.env.PORT;
const express = require("express");
const cors = require("cors");
const app = express();
const userRoute = require("./routes/user.routes");
const authRoute = require("./routes/auth.routes");
const carouselRoute = require("./routes/carousel.routes");
const pengaduanRoute = require("./routes/pengaduan.routes");
const kelasRoute = require("./routes/daftarKelas.routes");
const potonganHargaRoute = require("./routes/potonganHarga.routes")
const fasilitasRoute =require("./routes/fasilitas.routes")
const makananRoute =require("./routes/makananSehat.routes")
const statusGym =require("./routes/statusGYM.routes")
const verifyJWT = require("./middleware/verifyJWT");

app.use(cors());
app.use(express.json());

app.use(
  cors({
    origin: "http://localhost:8000", // Laravel berjalan di port 8000
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use("/auth", authRoute);
app.use("/user", userRoute);
app.use("/carousel", carouselRoute);
app.use("/pengaduan", pengaduanRoute);
app.use("/kelas", kelasRoute);
app.use("/potonganHarga", potonganHargaRoute);
app.use("/fasilitas", fasilitasRoute);
app.use("/makanan", makananRoute);
app.use("/status", statusGym);


app.listen(PORT, () => {
  console.log(`> listening at http://localhost:${PORT}`);
});
