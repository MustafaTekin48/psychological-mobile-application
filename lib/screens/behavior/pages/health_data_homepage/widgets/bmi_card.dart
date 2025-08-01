// BMI kısmı

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';

class BMICard extends StatelessWidget {
  final RxDouble bmi; // VKİ değeri
  final RxDouble height; // Boy değeri
  final RxDouble weight; // Kilo değeri
  final ValueChanged<double> onHeightChanged; // Boy değişimi için callback fonksiyon
  final ValueChanged<double> onWeightChanged; // Kilo değişimi için callback fonksiyon

  const BMICard({
    Key? key,
    required this.bmi,
    required this.height,
    required this.weight,
    required this.onHeightChanged,
    required this.onWeightChanged,
  }) : super(key: key);

  // VKİ kategorisini belirleme
  String _getBMICategory(double bmiValue) {
    if (bmiValue < 18.5) return 'Zayıf';
    if (bmiValue < 24.9) return 'Normal (Sağlıklı)';
    if (bmiValue < 29.9) return 'Kilolu';
    return 'Obez';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        // Kartın arka plan gradyanı ve kenar özellikleri
        gradient: const LinearGradient(
          colors: [AppColors.primaryColor, AppColors.accentColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık satırı
          Row(
            children: [
              Icon(FontAwesomeIcons.infoCircle, size: 30.0, color: Colors.white), // Bilgi ikonu
              const SizedBox(width: 10),
              Text(
                'Vücut Kitle İndeksi (VKİ)',
                style: AppTextStyles.heading.copyWith(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // VKİ bilgisi ve kategorisi
          Obx(() {
            double bmiValue = bmi.value; // Güncel VKİ değeri
            String category = _getBMICategory(bmiValue); // VKİ kategorisi

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // VKİ değeri
                Text(
                  'VKİ: ${bmiValue.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // VKİ kategorisi
                Text(
                  'Kategori: $category',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10), // Boşluk

                // Boy ve Kilo ayarları
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Boy: ${height.value.round()} cm',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Slider(
                      value: height.value, // Mevcut boy değeri
                      min: 100.0, // Minimum boy
                      max: 200.0, // Maksimum boy
                      divisions: 100, // Slider bölümleri
                      label: '${height.value.round()} cm', // Slider etiketi
                      onChanged: onHeightChanged, // Boy değişimi
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kilo: ${weight.value.round()} kg',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Slider(
                      value: weight.value, // Mevcut kilo değeri
                      min: 30.0, // Minimum kilo
                      max: 150.0, // Maksimum kilo
                      divisions: 120, // Slider bölümleri
                      label: '${weight.value.round()} kg', // Slider etiketi
                      onChanged: onWeightChanged, // Kilo değişimi
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // VKİ değer aralıkları bilgisi
                const Text(
                  'Zayıf: < 18.5, Normal (Sağlıklı): 18.5 - 24.9, Kilolu: 25 - 29.9, Obez: 30 ve üzeri',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
