import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class BasicEmotionAnalysisScreen extends StatefulWidget {
  final String imagePath;

  const BasicEmotionAnalysisScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  _BasicEmotionAnalysisScreenState createState() => _BasicEmotionAnalysisScreenState();
}

class _BasicEmotionAnalysisScreenState extends State<BasicEmotionAnalysisScreen> {
  late Interpreter _interpreter;
  String _emotion = "Analiz ediliyor...";
  bool _isModelLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadModel().then((_) {
      _analyzeEmotion(); // Model yüklendiğinde analiz başlasın
    });
  }

  /// 📌 **TensorFlow Lite Modelini Yükleme**
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/emotion_model.tflite');
      setState(() {
        _isModelLoaded = true;
      });
      print("✅ TensorFlow Lite modeli başarıyla yüklendi!");
    } catch (e) {
      print("🚨 Model yüklenirken hata oluştu: $e");
    }
  }

  /// 📌 **Görüntüyü Gri Tonlamaya Dönüştürme**
  img.Image convertToGrayscale(img.Image image) {
    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        int pixelColor = image.getPixel(x, y);
        int r = img.getRed(pixelColor);
        int g = img.getGreen(pixelColor);
        int b = img.getBlue(pixelColor);
        int gray = ((r + g + b) ~/ 3);
        image.setPixel(x, y, img.getColor(gray, gray, gray));
      }
    }
    return image;
  }

  /// 📌 **Duygu Analizini Yap**
  Future<void> _analyzeEmotion() async {
    if (!_isModelLoaded) return;

    try {
      File imageFile = File(widget.imagePath);
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());

      if (image == null) {
        setState(() => _emotion = "Görsel okunamadı!");
        return;
      }

      // 📌 **Görüntüyü 48x48 boyutuna getir ve gri tonlamaya çevir**
      img.Image resizedImage = img.copyResize(image, width: 48, height: 48);
      resizedImage = convertToGrayscale(resizedImage);

      // 📌 **TensorFlow Lite modeli için giriş verisini oluştur**
      List<List<List<List<double>>>> input = List.generate(
        1,
            (i) => List.generate(
          48,
              (j) => List.generate(
            48,
                (k) => [
              img.getRed(resizedImage.getPixel(j, k)).toDouble() / 255.0 // 🔥 Hata düzeltilmiş hali!
            ],
          ),
        ),
      );

      List<List<double>> output = List.generate(1, (_) => List.filled(7, 0.0));

      _interpreter.run(input, output);

      // 📌 **Modelin çıktısını al ve en yüksek skoru olan duygu indeksini belirle**
      int index = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      List<String> emotions = ["Kızgın", "Tiksinti", "Korku", "Mutlu", "Nötr", "Üzgün", "Şaşkın"];

      setState(() {
        _emotion = "Tahmini Duygu: ${emotions[index]}";
      });
    } catch (e) {
      print("🚨 Duygu analizi sırasında hata oluştu: $e");
      setState(() => _emotion = "Analiz edilemedi!");
    }
  }

  @override
  void dispose() {
    _interpreter.close(); // 📌 Modeli kapatmayı unutma!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Duygu Analizi")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(File(widget.imagePath), height: 300),
          const SizedBox(height: 20),
          Text(
            _emotion,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
