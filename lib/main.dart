import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Angka Sederhana',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Interpreter? _interpreter;
  String _hasilPrediksi = "AI belum dijalankan";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  // Fungsi untuk memuat model .tflite ke dalam memori HP
  void _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_mnist.tflite');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasilPrediksi = "Gagal memuat model: $e";
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menguji AI dengan gambar buatan sendiri (Angka 7)
  void _jalankanAI() {
    if (_interpreter == null) return;

    setState(() {
      _hasilPrediksi = "AI sedang berpikir...";
    });

    // 1. Buat gambar 28x28 warna hitam (0)
    img.Image gambarUji = img.Image(width: 28, height: 28);
    
    // 2. Gambar garis putih (255) membentuk angka 7 secara manual
    // Garis atas
    for (int x = 5; x < 23; x++) {
      gambarUji.setPixelRgb(x, 5, 255, 255, 255);
    }
    // Garis miring ke bawah
    for (int i = 0; i < 18; i++) {
      gambarUji.setPixelRgb(22 - i, 5 + i, 255, 255, 255);
    }

    // 3. Siapkan tempat input & output untuk AI
    // Input: 1 gambar, ukuran 28x28, 1 channel (grayscale)
    var input = List.filled(1 * 28 * 28 * 1, 0.0).reshape([1, 28, 28, 1]);
    // Output: 10 probabilitas (angka 0 sampai 9)
    var output = List.filled(1 * 10, 0.0).reshape([1, 10]);

    // 4. Ubah gambar jadi angka (normalisasi 0-255 jadi 0.0-1.0)
    for (int y = 0; y < 28; y++) {
      for (int x = 0; x < 28; x++) {
        var pixel = gambarUji.getPixel(x, y);
        // Ambil rata-rata RGB untuk grayscale
        double gray = (pixel.r + pixel.g + pixel.b) / 3.0;
        input[0][y][x][0] = gray / 255.0; 
      }
    }

    // 5. SURUH AI MENEBAAK!
    _interpreter!.run(input, output);

    // 6. Cari angka dengan probabilitas tertinggi
    int prediksi = 0;
    double keyakinan = 0.0;
    for (int i = 0; i < 10; i++) {
      if (output[0][i] > keyakinan) {
        keyakinan = output[0][i];
        prediksi = i;
      }
    }

    // 7. Tampilkan hasil
    setState(() {
      _hasilPrediksi = "Prediksi: $prediksi\nKeyakinan: ${(keyakinan * 100).toStringAsFixed(2)}%";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Angka Sederhana')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Tes AI dari Kode",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Kotak untuk nampilin hasil prediksi
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _hasilPrediksi,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Tombol untuk jalanin AI
                  ElevatedButton.icon(
                    onPressed: _jalankanAI,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("TEBAK GAMBAR (ANGKA 7)"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}