import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'MeditationJournalProvider.dart';

class meditation_stats extends StatefulWidget {
  final String? selectedEmotion;

  const meditation_stats({super.key, this.selectedEmotion});

  @override
  State<meditation_stats> createState() => _meditation_statsState();
}

class _meditation_statsState extends State<meditation_stats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<MeditationJournalProvider>(
          builder: (context, journalProvider, child) {
            final allEntries = journalProvider.diaryEntries;

            // Meditasyon türlerine göre filtreleme
            final breathEntries = allEntries.where((e) => e['theme'] == 'Nefes Farkındalığı Meditasyonu').toList();
            final bodyScanEntries = allEntries.where((e) => e['theme'] == 'Beden Tarama Meditasyonu').toList();
            final mindfulnessEntries = allEntries.where((e) => e['theme'] == 'Farkındalık Temelli Meditasyonu').toList();

            // Tüm meditasyonlar için duygu dağılımı
            Map<String, int> emotionCounts = {};
            for (var entry in allEntries) {
              String emotion = entry['emotion'];
              emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
            }

            // En çok hissedilen duyguyu bulma
            String mostFrequentEmotion = 'N/A';
            if (emotionCounts.isNotEmpty) {
              mostFrequentEmotion = emotionCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;
            }

            // Meditasyon türü istatistikleri
            Map<String, Map<String, dynamic>> meditationStats = {
              'Nefes Farkındalığı': {
                'count': breathEntries.length,
                'color': Colors.blue,
              },
              'Beden Tarama': {
                'count': bodyScanEntries.length,
                'color': Colors.green,
              },
              'Farkındalık Temelli': {
                'count': mindfulnessEntries.length,
                'color': Colors.purple,
              },
            };

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Meditasyon İstatistikleri',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Meditasyon Türü Dağılımı
                  const Text(
                    'Meditasyon Türleri:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    children: meditationStats.entries.map((entry) {
                      return Card(
                        color: entry.value['color'].withOpacity(0.1),
                        elevation: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14,
                                color: entry.value['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${entry.value['count']}',
                              style: TextStyle(
                                fontSize: 24,
                                color: entry.value['color'],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Toplam Meditasyon
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Toplam Meditasyon Sayısı:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${allEntries.length} Meditasyon',
                            style: const TextStyle(fontSize: 24, color: Color(0xFF3F3D56)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // En Çok Hissedilen Duygu
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'En Çok Hissedilen Duygu:',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: journalProvider.getEmotionColor(mostFrequentEmotion),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                mostFrequentEmotion,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: journalProvider.getEmotionColor(mostFrequentEmotion),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duygu Dağılımı
                  const Text(
                    'Duygu Dağılımı:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  emotionCounts.isEmpty
                      ? Center(
                    child: Text(
                      widget.selectedEmotion != null
                          ? 'Son meditasyonda hissedilen duygu: ${widget.selectedEmotion}'
                          : 'Kayıtlı veri yok',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: emotionCounts.keys.length,
                    itemBuilder: (context, index) {
                      String emotion = emotionCounts.keys.elementAt(index);
                      int count = emotionCounts[emotion]!;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: journalProvider.getEmotionColor(emotion),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$emotion: $count kez',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}