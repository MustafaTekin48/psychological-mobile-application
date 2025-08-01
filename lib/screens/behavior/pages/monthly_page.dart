// Gerekli paketlerin ve bağımlılıkların import edilmesi
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controllers/weight_controller.dart';
import '../controllers/shared_controller.dart'; // SharedController'ı import et
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/save_button.dart';

class MonthlyPage extends StatelessWidget {
  // WeightController ve SharedController'ı Getx ile al
  final WeightController weightController = Get.find<WeightController>();
  final SharedController sharedController = Get.find<SharedController>();

  // Sağlık metrikleri için gözlemlenebilir değişkenler (RxDouble)
  final RxDouble systolicPressure = 120.0.obs; // Büyük tansiyon
  final RxDouble diastolicPressure = 80.0.obs; // Küçük tansiyon
  final RxDouble bloodSugar = 90.0.obs;        // Kan şekeri
  final RxDouble pulseRate = 70.0.obs;         // Nabız

  MonthlyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aylık Sağlık Verileri', style: AppTextStyles.body), // AppBar başlığı
        backgroundColor: AppColors.backgroundColor, // Arka plan rengi
        centerTitle: true, // Başlık ortalanmış
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView( // Sayfa kaydırılabilir yapıda
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Sayfanın iç boşlukları
          child: Column(
            children: [
              _buildBloodPressureCard(context), // Tansiyon kartı
              const SizedBox(height: 20), // Kartlar arasında boşluk
              _buildSliderCard(
                context,
                title: 'Şeker',
                description: _getBloodSugarLevelDescription(bloodSugar.value), // Şeker seviyesine göre açıklama
                icon: FontAwesomeIcons.tint, // İkon
                value: bloodSugar,
                min: 0.0,
                max: 200.0,
                divisions: 200,
                unit: 'mg/dL',
                onChanged: (value) {
                  bloodSugar.value = value; // Değişiklik yapıldığında kan şekeri değerini güncelle
                },
              ),
              const SizedBox(height: 20),
              _buildSliderCard(
                context,
                title: 'Nabız',
                description: 'Normal Kadınlar: 60-90 bpm, Erkekler: 60-80 bpm', // Nabız ile ilgili açıklama
                icon: FontAwesomeIcons.heartbeat, // İkon
                value: pulseRate,
                min: 0.0,
                max: 150.0,
                divisions: 150,
                unit: 'bpm',
                onChanged: (value) {
                  pulseRate.value = value; // Değişiklik yapıldığında nabız değerini güncelle
                },
              ),
              const SizedBox(height: 20),
              _buildSliderCard(
                context,
                title: 'Vücut Ağırlığı',
                description: '',
                icon: FontAwesomeIcons.weight, // İkon
                value: weightController.weight, // Vücut ağırlığı kontrolünden alınır
                min: 30.0,
                max: 150.0,
                divisions: 120,
                unit: 'kg',
                onChanged: (value) {
                  weightController.weight.value = value; // Değişiklik yapıldığında kilo değerini güncelle
                },
              ),
              // Kaydet butonu, kullanıcı verilerini kaydeder
              const SizedBox(height: 20),
              SaveButton(
                label: 'Aylık', // Buton etiketi
                onPressed: () {
                  sharedController.saveData(
                    systolicPressure: systolicPressure.value,
                    diastolicPressure: diastolicPressure.value,
                    bloodSugar: bloodSugar.value,
                    pulseRate: pulseRate.value,
                    bodyWeight: weightController.weight.value, // Kilo bilgisi
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tansiyon kartını oluşturan widget
  Widget _buildBloodPressureCard(BuildContext context) {
    RxBool isExpanded = false.obs; // Kartın açık/kapalı durumu

    return GestureDetector(
      onTap: () {
        isExpanded.toggle(); // Kart tıklanarak genişletilip kapatılabilir
      },
      child: Container(
        padding: const EdgeInsets.all(16.0), // Kartın iç boşlukları
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor], // Gradyan renkler
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Kartın köşeleri yuvarlatılmış
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Gölge rengi ve opaklığı
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 4), // Gölgenin pozisyonu
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.heartbeat, size: 30.0, color: Colors.white), // Başlık ikonu
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Tansiyon',
                    style: AppTextStyles.heading.copyWith(fontSize: 18, color: Colors.white), // Başlık stili
                  ),
                ),
                Obx(() => Icon(
                  isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Açık/kapalı ikon
                  color: Colors.white70,
                )),
              ],
            ),
            Obx(() {
              if (!isExpanded.value) return const SizedBox.shrink(); // Kapalı durumda içeriği gizle
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Normal: 120/80 mmHg, Hipertansiyon: 140/90 mmHg, Hipotansiyon: 90/60 mmHg',
                    style: TextStyle(color: Colors.white70), // Tansiyon açıklaması
                  ),
                  const SizedBox(height: 10),
                  _buildBloodPressureSlider(
                    context,
                    'Büyük Tansiyon',
                    systolicPressure, // Büyük tansiyon kontrolü
                    200,
                    unit: 'mmHg',
                  ),
                  const SizedBox(height: 10),
                  _buildBloodPressureSlider(
                    context,
                    'Küçük Tansiyon',
                    diastolicPressure, // Küçük tansiyon kontrolü
                    200,
                    unit: 'mmHg',
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Tansiyon için slider oluşturan yardımcı fonksiyon
  Widget _buildBloodPressureSlider(
      BuildContext context,
      String title,
      RxDouble value,
      double max, {
        required String unit, // Birim
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Slider başlığı
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.5),
            trackHeight: 6.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayColor: AppColors.accentColor.withOpacity(0.2),
            thumbColor: Colors.white,
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorTextStyle: const TextStyle(color: Colors.black),
            valueIndicatorColor: Colors.white,
          ),
          child: Slider(
            value: value.value, // Mevcut değer
            min: 0,
            max: max,
            divisions: max.toInt(),
            label: '${value.value.round()} $unit', // Slider etiketi
            onChanged: (newValue) {
              value.value = newValue; // Değer değiştiğinde güncelle
            },
          ),
        ),
        Text(
          '${value.value.round()} $unit', // Güncel değer metni
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Genel slider kartı oluşturan fonksiyon
  Widget _buildSliderCard(
      BuildContext context, {
        required String title, // Başlık
        required String description, // Açıklama
        required IconData icon, // İkon
        required RxDouble value, // Değer
        required double min, // Minimum değer
        required double max, // Maksimum değer
        required int divisions, // Bölüm sayısı
        required String unit, // Birim
        required ValueChanged<double> onChanged, // Değişiklik fonksiyonu
      }) {
    RxBool isExpanded = false.obs; // Kart genişletme durumu

    return GestureDetector(
      onTap: () {
        isExpanded.toggle(); // Kart tıklanarak genişletilip kapatılabilir
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
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
            Row(
              children: [
                Icon(icon, size: 30.0, color: Colors.white), // Kart ikonu
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.heading.copyWith(fontSize: 18, color: Colors.white), // Başlık stili
                  ),
                ),
                Obx(() => Icon(
                  isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Genişletme/kapatma ikonu
                  color: Colors.white70,
                )),
              ],
            ),
            Obx(() {
              if (!isExpanded.value) return const SizedBox.shrink(); // Kart kapalıysa içeriği gizle
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(description, style: const TextStyle(color: Colors.white70)), // Açıklama
                  const SizedBox(height: 10),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.5),
                      trackHeight: 6.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      overlayColor: AppColors.accentColor.withOpacity(0.2),
                      thumbColor: Colors.white,
                      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                      valueIndicatorTextStyle: const TextStyle(color: Colors.black),
                      valueIndicatorColor: Colors.white,
                    ),
                    child: Slider(
                      value: value.value, // Mevcut değer
                      min: min, // Minimum değer
                      max: max, // Maksimum değer
                      divisions: divisions, // Bölüm sayısı
                      label: '${value.value.round()} $unit', // Slider etiketi
                      onChanged: onChanged, // Değişiklik fonksiyonu
                    ),
                  ),
                  Text(
                    '${value.value.round()} $unit', // Güncel değer metni
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Kan şekeri seviyesine göre açıklama döndüren fonksiyon
  String _getBloodSugarLevelDescription(double value) {
    if (value < 70) {
      return 'Düşük Şeker';
    } else if (value <= 99) {
      return 'Normal Şeker';
    } else if (value <= 125) {
      return 'Prediyabet';
    } else {
      return 'Diyabet';
    }
  }
}
