# 🤖 AI Angka Sederhana (Flutter + TFLite)

Project iseng tapi serius: Menjalankan model AI (TensorFlow Lite) untuk menebak angka tulisan tangan (MNIST) langsung di dalam aplikasi Android.

Aplikasi ini dibuat **100% dari HP** menggunakan GitHub Actions sebagai *builder* (tanpa laptop/PC).

## ✨ Fitur
- Menggunakan model AI `model_mnist.tflite` (hasil training dari Google Colab).
- Tanpa kamera/upload gambar (fokus ke *logic* AI dulu).
- Tombol ajaib: Saat ditekan, aplikasi akan men- *generate* gambar angka "7" secara manual di dalam kode, lalu menyuruh AI menebaknya.
- Menampilkan hasil prediksi beserta persentase keyakinan AI.

## 📁 Struktur File
Project ini sengaja dibuat minimalis:
- `main.dart` : Kode utama aplikasi & logika AI.
- `pubspec.yaml` : Daftar library (tflite_flutter & image).
- `model_mnist.tflite` : Otak AI-nya.
- `.github/workflows/build.yml` : Robot yang meng-compile kode jadi APK.

## 🚀 Cara Build APK (Via GitHub Actions)
1. Pastikan semua file sudah di- *push* ke repository GitHub ini.
2. Buka tab **Actions** di repository ini.
3. Pilih workflow **"Build APK AI"** di sebelah kiri.
4. Klik tombol **"Run workflow"** di sebelah kanan.
5. Tunggu sekitar 5-10 menit sampai proses selesai (centang hijau ✅).
6. Klik workflow yang sudah selesai tersebut.
7. Scroll ke paling bawah, di bagian **Artifacts**, klik **aplikasi-ai-angka** untuk mendownload file `.zip`.
8. Ekstrak file zip tersebut, di dalamnya ada file `app-release.apk`.
9. Install APK tersebut di HP Android kamu!

## 🧠 Cara Kerja AI-nya
1. Aplikasi memuat file `model_mnist.tflite` ke dalam memori.
2. Saat tombol ditekan, kode Dart membuat gambar 28x28 pixel dan menggambar garis putih membentuk angka 7.
3. Gambar tersebut diubah menjadi *array* angka (normalisasi 0.0 - 1.0).
4. Model AI memproses *array* tersebut dan mengeluarkan 10 probabilitas (angka 0-9).
5. Angka dengan probabilitas tertinggi ditampilkan di layar.

---
*Dibuat untuk belajar AI & Flutter dari HP.*