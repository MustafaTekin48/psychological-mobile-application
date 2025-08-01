import 'package:flutter/material.dart';

class MeditationJournalProvider extends ChangeNotifier {
  // Günlük girişleri listesi
  final List<Map<String, dynamic>> _diaryEntries = [];

  List<Map<String, dynamic>> get diaryEntries => _diaryEntries;

  // Yeni bir günlük girişi ekleme metodu
  void addEntry({
    required String emotion,
    required DateTime date,
    int? rating, // Opsiyonel olarak bir derecelendirme
    String? note, // Opsiyonel olarak bir not
  }) {
    _diaryEntries.add({
      'emotion': emotion,
      'date': date,
      'rating': rating,
      'note': note,
    });
    print('Added entry: emotion=$emotion, date=$date'); // <-- Debug için ekleyin

    notifyListeners(); // Dinleyicilere değişiklik olduğunu bildir
  }

  // Belirli bir gün için girişleri döndüren yardımcı metod
  List<Map<String, dynamic>> getEntriesForDay(DateTime day) {
    return _diaryEntries.where((entry) {
      final entryDate = entry['date'] as DateTime;
      return entryDate.year == day.year &&
          entryDate.month == day.month &&
          entryDate.day == day.day;
    }).toList();
  }

  // Duyguya göre renk döndüren yardımcı metod
  Color getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mutlu':
        return Colors.green.shade400; // Daha doygun bir yeşil
      case 'normal':
        return Colors.blueGrey.shade400; // Normal için mavi-gri
      case 'heyecanlı':
        return Colors.orange.shade400; // Heyecanlı için turuncu
      case 'üzgün':
        return Colors.blue.shade400; // Üzgün için mavi
      case 'kızgın':
        return Colors.red.shade400; // Kızgın için kırmızı
      case 'korkulu':
        return Colors.purple.shade400; // Korkulu için mor
      case 'yorgun':
        return Colors.brown.shade400; // Yorgun için kahverengi
      default:
        return Colors.grey.shade400; // Varsayılan gri
    }
  }
}