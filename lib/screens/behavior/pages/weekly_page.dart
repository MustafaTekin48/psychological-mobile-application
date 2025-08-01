// Haftalık veriler sayfası
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../controllers/shared_controller.dart'; // SharedController'ı import et
import '../widgets/save_button.dart';

class WeeklyPage extends StatelessWidget {
  // SharedController'ı Getx ile tanımla
  final SharedController sharedController = Get.find<SharedController>();

  // Haftalık veriler için gözlemlenebilir değişkenler (RxDouble)
  final RxDouble strenuousExercise = 0.0.obs; // Zorlu egzersiz sayısı
  final RxDouble moderateExercise = 0.0.obs;  // Orta dereceli egzersiz sayısı
  final RxDouble lightExercise = 0.0.obs;     // Hafif egzersiz sayısı
  final RxDouble alcoholConsumption = 0.0.obs; // Alkol tüketimi
  final RxDouble cigaretteConsumption = 0.0.obs; // Sigara tüketimi

  WeeklyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Haftalık Sağlık Verileri', style: AppTextStyles.body), // AppBar başlığı
        backgroundColor: AppColors.backgroundColor, // AppBar arka plan rengi
        centerTitle: true, // Başlık ortalanmış
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView( // Sayfanın kaydırılabilir yapıda olması
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Sayfanın kenar boşlukları
          child: Column(
            children: [
              // Spor yapma aralığı kartı
              _buildExerciseCard(
                context,
                icon: FontAwesomeIcons.running, // Kart ikonu
                iconSize: 30.0,
                title: 'Spor Yapma Aralığı',
              ),
              const SizedBox(height: 20), // Kartlar arasında boşluk
              // Haftalık sigara kullanımı kartı
              _buildCard(
                context,
                icon: FontAwesomeIcons.smoking, // Kart ikonu
                iconSize: 30.0,
                title: 'Haftalık Sigara Kullanımı',
                description: () => _getCigaretteRiskLevel(cigaretteConsumption.value.toInt()), // Açıklama
                reactiveValue: () => '${cigaretteConsumption.value.round()} adet', // Güncel değer
                sliderValue: cigaretteConsumption,
                min: 0.0,
                max: 200.0,
                divisions: 200,
                onChanged: (value) {
                  cigaretteConsumption.value = value; // Değer güncellemesi
                },
              ),
              const SizedBox(height: 20),
              // Haftalık alkol tüketimi kartı
              _buildCard(
                context,
                icon: FontAwesomeIcons.wineGlass, // Kart ikonu
                iconSize: 30.0,
                title: 'Haftalık Alkol Tüketimi',
                description: () => 'Kadınlar için haftada 7 içkiyi, erkekler için haftada 14 içkiyi geçmemelidir.',
                reactiveValue: () => '${alcoholConsumption.value.round()} birim',
                sliderValue: alcoholConsumption,
                min: 0.0,
                max: 200.0,
                divisions: 200,
                onChanged: (value) {
                  alcoholConsumption.value = value; // Değer güncellemesi
                },
              ),
              // Kaydet butonu
              const SizedBox(height: 20),
              SaveButton(
                label: 'Haftalık', // Buton etiketi
                onPressed: () {
                  // Haftalık verileri sharedController'a kaydet
                  sharedController.saveData(
                    strenuousExercise: strenuousExercise.value.toInt(),
                    moderateExercise: moderateExercise.value.toInt(),
                    lightExercise: lightExercise.value.toInt(),
                    alcoholConsumption: alcoholConsumption.value.toInt(),
                    cigaretteUsage: cigaretteConsumption.value.toInt(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Spor yapma aralığı kartı oluşturan fonksiyon
  Widget _buildExerciseCard(
      BuildContext context, {
        required IconData icon, // İkon
        required double iconSize, // İkon boyutu
        required String title, // Başlık
      }) {
    RxBool isExpanded = false.obs; // Kartın genişleme durumu

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
                Icon(icon, size: iconSize, color: Colors.white), // Kart ikonu
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
                  // Zorlu egzersiz kaydırıcısı
                  _buildSliderWithDescription(
                    context,
                    'Zorlu Egzersiz (0-50)',
                    strenuousExercise,
                    50,
                    description: 'Örneğin: Koşma, futbol, basketbol, tempolu bisiklet',
                    factor: 9, // Puan faktörü
                  ),
                  const SizedBox(height: 10),
                  // Orta egzersiz kaydırıcısı
                  _buildSliderWithDescription(
                    context,
                    'Orta Egzersiz (0-50)',
                    moderateExercise,
                    50,
                    description: 'Örneğin: Yürüyüş, tenis, yüzme, hafif bisiklet',
                    factor: 5, // Puan faktörü
                  ),
                  const SizedBox(height: 10),
                  // Hafif egzersiz kaydırıcısı
                  _buildSliderWithDescription(
                    context,
                    'Hafif Egzersiz (0-50)',
                    lightExercise,
                    50,
                    description: 'Örneğin: Yoga, yürüyüş, balık tutma',
                    factor: 3, // Puan faktörü
                  ),
                  const SizedBox(height: 20),
                  _buildTotalScore(), // Toplam puan göstergesi
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  // Egzersiz kaydırıcısı ve açıklama metni
  Widget _buildSliderWithDescription(
      BuildContext context,
      String title,
      RxDouble value,
      double max, {
        required String description, // Açıklama metni
        required int factor, // Puan faktörü
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Başlık stili
        ),
        const SizedBox(height: 5),
        Text(
          description,
          style: const TextStyle(color: Colors.white70), // Açıklama metni stili
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
            value: value.value,
            min: 0,
            max: max,
            divisions: max.toInt(),
            label: '${value.value.round()} kez', // Kaydırıcı etiketi
            onChanged: (newValue) {
              value.value = newValue; // Değer güncellemesi
            },
          ),
        ),
        Obx(() {
          double score = value.value * factor; // Puan hesaplaması
          return Text(
            'Haftalık Puan: ${score.toStringAsFixed(1)} (${value.value.round()} x $factor)',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ],
    );
  }

  // Toplam puan hesaplama ve yorum
  Widget _buildTotalScore() {
    return Obx(() {
      double totalScore = strenuousExercise.value * 9 +
          moderateExercise.value * 5 +
          lightExercise.value * 3;

      String interpretation = '';
      if (totalScore >= 24) {
        interpretation = 'Aktif'; // Yüksek puan
      } else if (totalScore >= 14) {
        interpretation = 'Orta Derecede Aktif'; // Orta puan
      } else {
        interpretation = 'Yetersiz Aktif/Hareketsiz'; // Düşük puan
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Toplam Puan: ${totalScore.toStringAsFixed(1)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Yorum: $interpretation',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ],
      );
    });
  }

  // Genel kart yapısı oluşturan fonksiyon
  Widget _buildCard(
      BuildContext context, {
        required IconData icon, // Kart ikonu
        required double iconSize, // İkon boyutu
        required String title, // Kart başlığı
        required String Function() description, // Açıklama fonksiyonu
        required String Function() reactiveValue, // Güncel değer fonksiyonu
        required RxDouble sliderValue, // Kaydırıcı değeri
        required double min, // Minimum değer
        required double max, // Maksimum değer
        required int divisions, // Bölüm sayısı
        required ValueChanged<double> onChanged, // Değer değişiklik fonksiyonu
      }) {
    RxBool isExpanded = false.obs; // Kart genişleme durumu

    return GestureDetector(
      onTap: () {
        isExpanded.toggle(); // Kartın genişleme durumunu değiştir
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor], // Gradyan renkler
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Kartın köşeleri yuvarlatılmış
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Gölge ayarları
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
                Icon(icon, size: iconSize, color: Colors.white), // Kart ikonu
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
                  Text(description(), style: const TextStyle(color: Colors.white70)), // Açıklama metni
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
                      value: sliderValue.value, // Kaydırıcı değeri
                      min: min,
                      max: max,
                      divisions: divisions,
                      label: reactiveValue(), // Kaydırıcı etiketi
                      onChanged: (newValue) {
                        sliderValue.value = newValue; // Değer güncellemesi
                        onChanged(newValue);
                      },
                    ),
                  ),
                  Text(
                    reactiveValue(), // Güncel değer metni
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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

  // Sigara kullanımına göre risk seviyesini belirleyen fonksiyon
  String _getCigaretteRiskLevel(int cigarettes) {
    if (cigarettes < 7) {
      return 'Düşük Risk';
    } else if (cigarettes < 42) {
      return 'Orta Risk';
    } else if (cigarettes < 77) {
      return 'Yüksek Risk';
    } else {
      return 'Çok Yüksek Risk';
    }
  }
}
