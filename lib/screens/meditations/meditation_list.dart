import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/Bodyscan/bodyscanexplain.dart';
import 'package:flutter_application_1/screens/meditations/Breathawarness/breathawarenessexplain.dart';
// import 'package:google_fonts/google_fonts.dart'; // Bu import kullanılmadığı için kaldırılabilir.

import '../scales/NotificationHelper.dart'; // Bu yolun doğru olduğundan emin olun
// import 'Bodyscan/BodyScan.dart'; // Bu import kullanılmadığı için kaldırılabilir.
// import 'Breathawarness/BreathAwareness.dart'; // Bu import kullanılmadığı için kaldırılabilir.
import 'Mindfulness/FirstMindfulnessExplain.dart';

class meditation_list extends StatefulWidget {
  const meditation_list({super.key});

  @override
  State<meditation_list> createState() => _meditation_listState();
}

class _meditation_listState extends State<meditation_list> {
  @override
  void initState() {
    super.initState();
    // Uygulama başladığında NotificationHelper'ı başlatmak çok önemlidir.
    // İdeal olarak, bu main.dart dosyanızda veya bir açılış ekranında yapılmalıdır.
    // Ancak gösterim amacıyla, ilk başlatmadan sonra birden fazla kez çağrılması zararsız olsa da,
    // burada da başlatıldığından emin olacağız.
    NotificationHelper.initialize();
  }

  // Günlük meditasyon hatırlatıcısını ayarlama fonksiyonu
  void _scheduleDailyMeditationReminder() {
    // Bildirim için istenen zamanı ayarlayın (örneğin, akşam 8:00)
    final now = DateTime.now();
    DateTime scheduledTime = DateTime(now.year, now.month, now.day, 20, 0, 0); // Akşam 8:00 (20:00)

    // Eğer bugünün planlanan saati zaten geçmişse, yarın için planlayın
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    NotificationHelper.scheduleNotification(
      'Meditasyon Zamanı!',
      'Günün meditasyonunu yaptınız mı? Kendinize zaman ayırmayı unutmayın!',
      scheduledTime,
    );

    // Kullanıcıya bir onay mesajı gösterin
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Günlük meditasyon hatırlatıcısı ${scheduledTime.hour}:${scheduledTime.minute.toString().padLeft(2, '0')} için ayarlandı!'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Meditasyon Listesi', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildScaleCard(
              context,
              title: 'Farkındalık Temelli Meditasyon',
              description: 'Şu ana odaklanmak, otomatik düşünceleri fark etmek, zihni geçmiş/gelecekten uzaklaştırmak için Farkındalık Temelli Meditasyon yapın.',
              icon: Icons.self_improvement,
              onTap: () {
                // Meditasyon ekranına gitmeden önce veya sonra hatırlatıcıyı ayarla
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Firstmindfulnessexplain()),
                ).then((_) {
                  // Ekran geri döndüğünde veya navigasyon tamamlandığında hatırlatıcıyı ayarla
                  _scheduleDailyMeditationReminder();
                });
              },
            ),
            _buildScaleCard(
              context,
              title: 'Beden Tarama Meditasyonu',
              description: 'Bedensel farkındalığı artırmak, stres ve gerginliği tanımak ve serbest bırakmak için Beden Tarama Meditasyonu yapın.',
              icon: Icons.accessibility_new,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bodyscanexplain()),
                ).then((_) {
                  _scheduleDailyMeditationReminder();
                });
              },
            ),
            _buildScaleCard(
              context,
              title: 'Nefes Farkındalığı Meditasyonu',
              description: 'Zihni yatıştırmak, stresli anda "şimdi"ye dönmek, gevşemeyi artırmak için Nefes Farkındalığı Meditasyonu yapın.',
              icon: Icons.air,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => breathawrenessexplain()),
                ).then((_) {
                  _scheduleDailyMeditationReminder();
                });
              },
            ),
            // Artık ayrı bir düğmeye gerek yok, kartlara basıldığında otomatik ayarlanacak.
          ],
        ),
      ),
    );
  }

  Widget _buildScaleCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.teal[50],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.teal[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.teal,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}