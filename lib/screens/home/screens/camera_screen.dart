import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'tflite_helper.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? cameras;
  Future<void>? _initializeControllerFuture;
  String? imagePath;
  EmotionAnalyzer emotionAnalyzer = EmotionAnalyzer();
  String emotionResult = "Duygu Analizi Yapılmadı";
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  /// 📌 **Kamerayı Başlatma**
  Future<void> initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras!.isEmpty) {
        setState(() {
          emotionResult = "Kamera bulunamadı!";
        });
        return;
      }
      _controller = CameraController(cameras![0], ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print("🚨 Kamera başlatılırken hata oluştu: $e");
      setState(() {
        emotionResult = "Kamera başlatılamadı!";
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  /// 📌 **Fotoğraf Çekme ve Modeli Çalıştırma**
  Future<void> takePicture() async {
    if (_controller == null || isProcessing) return;
    setState(() => isProcessing = true);

    try {
      await _initializeControllerFuture;
      final XFile image = await _controller!.takePicture();

      final Directory appDir = await getApplicationDocumentsDirectory();
      final String filePath = '${appDir.path}/emotion.jpg';
      await File(image.path).copy(filePath);

      setState(() {
        imagePath = filePath;
        emotionResult = "Analiz ediliyor...";
      });

      // 📌 Modeli çalıştır ve sonucu al
      String result = await emotionAnalyzer.analyzeImage(File(filePath));

      setState(() {
        emotionResult = "Duygu: $result";
        isProcessing = false;
      });

    } catch (e) {
      print("🚨 Fotoğraf çekme hatası: $e");
      setState(() {
        emotionResult = "Fotoğraf çekilemedi!";
        isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Duygu Analizi Kamera')),
      body: Column(
        children: [
          Expanded(
            child: _controller == null
                ? const Center(child: CircularProgressIndicator())
                : CameraPreview(_controller!),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: isProcessing ? null : takePicture,
            child: isProcessing
                ? const CircularProgressIndicator()
                : const Text("📷 Fotoğraf Çek"),
          ),
          const SizedBox(height: 20),
          Text(
            emotionResult,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          if (imagePath != null) ...[
            const SizedBox(height: 10),
            Image.file(File(imagePath!), height: 200),
          ],
        ],
      ),
    );
  }
}

