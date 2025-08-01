import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class EmotionAnalyzer {
  late Interpreter _interpreter;
  List<String> labels = ["Angry", "Disgust", "Fear", "Happy", "Neutral", "Sad", "Surprise"];

  EmotionAnalyzer() {
    loadModel();
  }

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset("assets/models/emotion_model.tflite");
  }

  String analyzeImage(File imageFile) {
    img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
    if (image == null) return "Hata";

    // Görüntüyü 48x48'e küçült
    img.Image resizedImage = img.copyResize(image, width: 48, height: 48);
    List<List<List<double>>> input = List.generate(48, (_) => List.generate(48, (_) => [0.0]));

    for (int i = 0; i < 48; i++) {
      for (int j = 0; j < 48; j++) {
        input[i][j][0] = resizedImage.getPixel(i, j).toDouble() / 255.0;
      }
    }

    List<double> output = List.filled(7, 0.0);
    _interpreter.run(input, output);

    int maxIndex = output.indexOf(output.reduce((curr, next) => curr > next ? curr : next));
    return labels[maxIndex];  // Tahmin edilen duygu etiketi
  }
}
