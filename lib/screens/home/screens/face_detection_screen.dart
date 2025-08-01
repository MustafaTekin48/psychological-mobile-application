import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key});

  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late Interpreter _interpreter;
  bool _modelLoaded = false;
  File? _image;
  String _emotionResult = "Henüz analiz yapılmadı.";
  String _emoji = "❔";

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      print("📌 TensorFlow Lite modeli yükleniyor...");
      _interpreter = await Interpreter.fromAsset('assets/models/emotion_model.tflite');
      print("✅ TensorFlow Lite modeli başarıyla yüklendi!");
      setState(() {
        _modelLoaded = true;
      });
    } catch (e) {
      print("🚨 Model yüklenirken hata oluştu: $e");
      setState(() {
        _emotionResult = "Model yüklenemedi!";
        _emoji = "⚠️";
      });
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _emotionResult = "Analiz ediliyor...";
        _emoji = "⏳";
      });

      analyzeImage(_image!);
    }
  }

  void analyzeImage(File imageFile) async {
    if (!_modelLoaded) {
      setState(() {
        _emotionResult = "Model yüklenemedi!";
        _emoji = "⚠️";
      });
      return;
    }

    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) {
      setState(() {
        _emotionResult = "Görsel işlenemedi!";
        _emoji = "❌";
      });
      return;
    }

    img.Image resizedImage = img.copyResize(image, width: 48, height: 48);
    List<List<List<List<double>>>> input = List.generate(
        1, (_) => List.generate(48, (_) => List.generate(48, (_) => [0.0])));

    for (int i = 0; i < 48; i++) {
      for (int j = 0; j < 48; j++) {
        int pixel = resizedImage.getPixel(i, j);
        int r = (pixel >> 16) & 0xFF;
        int g = (pixel >> 8) & 0xFF;
        int b = pixel & 0xFF;

        double gray = (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
        input[0][i][j][0] = gray;
      }
    }

    List<List<double>> output = [List.filled(7, 0.0)];

    try {
      _interpreter.run(input, output);
      print("📌 Model Çıktısı: $output");

      List<double> probabilities = output[0];
      int maxIndex = probabilities.indexOf(probabilities.reduce((curr, next) => curr > next ? curr : next));

      List<String> labels = [
        "Öfkeli",
        "Tiksinti",
        "Korku",
        "Mutlu",
        "Nötr",
        "Üzgün",
        "Şaşkın"
      ];
      List<String> emojis = ["😠", "🤢", "😨", "😊", "😐", "😢", "😲"];

      setState(() {
        _emotionResult = labels[maxIndex];
        _emoji = emojis[maxIndex];
      });

    } catch (e) {
      setState(() {
        _emotionResult = "Analiz başarısız!";
        _emoji = "🚨";
      });
      print("🚨 Model çalıştırılamadı: $e");
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Duygu Analizi",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 📸 **Fotoğraf Alanı (Ortalanmış)**
            Center(
              child: _image == null
                  ? Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(_image!, height: 250, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 20),

            // 📌 **Duygu Sonucu Kartı**
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  children: [
                    Text(
                      _emoji,
                      style: const TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _emotionResult,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 📌 **Butonlar**
            if (_image == null) ...[
              _buildModernButton("Kameradan Çek", Icons.camera_alt, Colors.blue, () => pickImage(ImageSource.camera)),
              const SizedBox(height: 15),
              _buildModernButton("Galeriden Seç", Icons.photo, Colors.green, () => pickImage(ImageSource.gallery)),
            ] else ...[
              _buildModernButton("Tekrar Analiz Yap", Icons.replay, Colors.orange, () {
                setState(() {
                  _image = null;
                  _emotionResult = "Henüz analiz yapılmadı.";
                  _emoji = "❔";
                });
              }),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton(String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(text, style: GoogleFonts.poppins(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
