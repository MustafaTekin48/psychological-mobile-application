// Veriler kısmı
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/behavior/pages/health_data_homepage/widgets/bmi_card.dart';
import 'package:flutter_application_1/screens/behavior/pages/health_data_homepage/widgets/data_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../controllers/shared_controller.dart';

class FixedPage extends StatelessWidget {
  final SharedController sharedController = Get.find<SharedController>(); // SharedController'ı Getx ile al

  // Boy, kilo ve VKİ (Vücut Kitle İndeksi) için RxDouble değişkenler
  final RxDouble height = 170.0.obs; // Boy (cm)
  final RxDouble weight = 70.0.obs;  // Kilo (kg)
  final RxDouble bmi = 0.0.obs;      // VKİ (Vücut Kitle İndeksi)

  FixedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sağlık Verileri', style: AppTextStyles.body),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView( // Ekranın kaydırılabilir olması için kullanıldı
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 1.0), // Dış boşluklar
          child: Column(
            children: [
              // VKİ kartını oluştur
              BMICard(
                bmi: bmi,
                height: height,
                weight: weight,
                onHeightChanged: (value) {
                  height.value = value; // Boy değeri değiştirildiğinde güncellenir
                  _calculateBMI(); // VKİ yeniden hesaplanır
                },
                onWeightChanged: (value) {
                  weight.value = value; // Kilo değeri değiştirildiğinde güncellenir
                  _calculateBMI(); // VKİ yeniden hesaplanır
                },
              ),
              const SizedBox(height: 10), // Boşluk
              Obx(() => _buildSwiper()) // Verileri göstermek için swiper widget'ı
            ],
          ),
        ),
      ),
    );
  }

  // VKİ'yi hesaplayan fonksiyon
  void _calculateBMI() {
    if (height.value > 0) {
      double heightInMeters = height.value / 100; // Boyu metreye çevirme
      bmi.value = weight.value / (heightInMeters * heightInMeters); // VKİ hesapla
    }
  }

  // Verileri göstermek için swiper widget'ı
  Widget _buildSwiper() {
    // Gösterilecek veri etiketleri ve içerikler
    final List<String> labels = ["Günlük Veriler", "Haftalık Veriler", "Aylık Veriler"];
    final List<Map<String, dynamic>> data = [
      {
        "Uyku Süresi": "${sharedController.sleepHours.value} saat",
        "Sigara Kullanımı": "${sharedController.cigaretteUsage.value} adet",
        "Alkol Tüketimi": "${sharedController.alcoholConsumption.value} birim",
        "Su Tüketimi": "${sharedController.waterIntake.value} bardak",
      },
      {
        "Zorlu Egzersiz": "${sharedController.strenuousExercise.value} kere",
        "Orta Egzersiz": "${sharedController.moderateExercise.value} kere",
        "Hafif Egzersiz": "${sharedController.lightExercise.value} kere",
        "Toplam Alkol": "${sharedController.alcoholConsumption.value} birim",
        "Sigara": "${sharedController.cigaretteUsage.value} adet",
      },
      {
        "Büyük Tansiyon": "${sharedController.systolicPressure.value} mmHg",
        "Küçük Tansiyon": "${sharedController.diastolicPressure.value} mmHg",
        "Kan Şekeri": "${sharedController.bloodSugar.value} mg/dL",
        "Nabız": "${sharedController.pulseRate.value} bpm",
        "Vücut Ağırlığı": "${sharedController.bodyWeight.value} kg",
      }
    ];

    return Container(
      height: 300, // Swiper yüksekliği
      child: Swiper(
        itemCount: labels.length, // Swiper item sayısı
        itemBuilder: (BuildContext context, int index) {
          return DataCard(
            title: labels[index], // Kart başlığı
            data: data[index], // Kart verileri
            icon: FontAwesomeIcons.chartLine, // Kart ikonu
          );
        },
        pagination: const SwiperPagination(
          alignment: Alignment.bottomCenter, // Sayfalama konumu
          builder: DotSwiperPaginationBuilder(
            activeColor: AppColors.primaryColor,
            color: Colors.grey,
            size: 8.0,
            activeSize: 12.0,
          ),
        ),
        control: const SwiperControl(
          color: AppColors.primaryColor, // Kontrol düğmesi rengi
        ),
        viewportFraction: 0.92, // Görünüm oranı
        scale: 0.95, // Swiper ölçeklendirme
      ),
    );
  }
}
