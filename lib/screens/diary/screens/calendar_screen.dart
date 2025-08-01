import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart'; // Dil desteği için

class CalendarScreen extends StatefulWidget {
  final List<Map<String, dynamic>> diaryEntries; // Günlük girişlerini buradan alacağız

  CalendarScreen({required this.diaryEntries});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now(); // Varsayılan olarak bugünkü tarih seçili
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('tr_TR'); // Türkçe dil desteği için tarih formatlaması
  }

  // Seçilen gün için emotion'a göre renk belirleme
  Color _getEmotionColorForDay(DateTime day) {
    List<Map<String, dynamic>> entries = _getEntriesForDay(day);
    if (entries.isEmpty) {
      return Colors.grey.shade400;
    }
    String emotion = entries.first['emotion'];
    return _getEmotionColor(emotion).withOpacity(0.6);
  }

  // Duyguya göre arka plan rengini döndüren fonksiyon
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mutlu':
        return Color(0xFFFFF3B0);
      case 'heyecanlı':
        return Color(0xFFFFD1A4);
      case 'normal':
        return Color(0xFFB2E0A8);
      case 'üzgün':
        return Color(0xFFAEC6FF);
      case 'kızgın':
        return Color(0xFFFFB3B3);
      case 'korkulu':
        return Color(0xFFD1B3FF);
      default:
        return Colors.black;
    }
  }

  // Belirli bir gün için tüm girişleri almak
  List<Map<String, dynamic>> _getEntriesForDay(DateTime day) {
    return widget.diaryEntries.where((entry) {
      final entryDate = entry['date']; // Tarih değişkenini burada alıyoruz
      if (entryDate != null) { // Tarih null değilse kontrol ediyoruz
        return entryDate.day == day.day &&
            entryDate.month == day.month &&
            entryDate.year == day.year;
      }
      return false; // Null ise bu girdiyi atlıyoruz
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> selectedDayEntries = _getEntriesForDay(_selectedDay);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Takvim', // "Takvim" başlığı, geri butonu olmadan sadece text
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TableCalendar(
            focusedDay: _focusedDay,
            locale: 'tr_TR', // Türkçe dil desteği
            daysOfWeekHeight: 40,
            daysOfWeekVisible: true,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            onFormatChanged: (format) {
              if (format == CalendarFormat.month) {
                return;
              }
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
            ),
            eventLoader: (day) {
              return _getEntriesForDay(day).map((entry) {
                return entry['emotion'];
              }).toList();
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: Colors.black, // Tarih metin rengi
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.0),
          Expanded(
            child: selectedDayEntries.isEmpty
                ? Center(
              child: Text(
                'Bu gün için bir giriş yok',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: selectedDayEntries.length,
              itemBuilder: (context, index) {
                final entry = selectedDayEntries[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: _getEmotionColor(entry['emotion']).withOpacity(0.6), // Günlük girişine renk
                  child: ListTile(
                    title: Text(
                      '${entry['emotion']} - ${entry['rating']}/10',
                      style: TextStyle(color: Colors.black87),
                    ),
                    subtitle: Text(
                      entry['reason'],
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
