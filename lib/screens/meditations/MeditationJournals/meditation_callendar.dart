import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class meditation_callendar extends StatefulWidget {
  final bool meditationCompletedToday;
  final String? selectedEmotion;
  final String? meditationThemeName;

  const meditation_callendar({
    super.key,
    this.meditationCompletedToday = false,
    this.selectedEmotion,
    this.meditationThemeName,
  });

  @override
  State<meditation_callendar> createState() => _meditation_callendarState();
}

class _meditation_callendarState extends State<meditation_callendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, Map<String, String>> _meditationEntries = {};

  @override
  void initState() {
    super.initState();
    _loadMeditationEntries();
  }

  Future<void> _loadMeditationEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString('meditationEntries');
    if (entriesJson != null) {
      Map<String, dynamic> decodedMap = json.decode(entriesJson);
      setState(() {
        _meditationEntries = decodedMap.map((key, value) {
          return MapEntry(
            DateTime.parse(key).toLocal(),
            Map<String, String>.from(value),
          );
        });
      });
    }

    if (widget.meditationCompletedToday && widget.meditationThemeName != null) {
      _addMeditationEntry(
        DateTime.now(),
        widget.selectedEmotion,
        widget.meditationThemeName!,
      );
    }
  }

  Future<void> _saveMeditationEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> entriesToSave = _meditationEntries.map((key, value) {
      return MapEntry(key.toIso8601String(), value);
    });

    final String entriesJson = json.encode(entriesToSave);
    await prefs.setString('meditationEntries', entriesJson);
  }

  void _addMeditationEntry(DateTime date, String? emotion, String themeName) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);

    setState(() {
      _meditationEntries[normalizedDate] = {
        'emotion': emotion ?? widget.selectedEmotion ?? 'Bilinmiyor',
        'theme': themeName,
      };
    });
    _saveMeditationEntries();
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    DateTime normalizedDay = DateTime(day.year, day.month, day.day);
    return _meditationEntries.containsKey(normalizedDay) ? [true] : [];
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String>? selectedDayEntry;
    if (_selectedDay != null) {
      selectedDayEntry = _meditationEntries[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)];
    }

    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditasyon Takvimi', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF3F3D56),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                markerDecoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                markerSize: 8.0,
              ),
              eventLoader: _getEventsForDay,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_selectedDay != null && selectedDayEntry != null) ...[
                      Text(
                        'Seçilen gün: ${_selectedDay!.toLocal().toIso8601String().split('T')[0]}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${selectedDayEntry?['theme'] ?? "Kayıtlı Meditasyon"}\nDuygu: ${selectedDayEntry?['emotion'] ?? "Bilinmiyor"}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ]
                    else if (_selectedDay != null &&
                        isSameDay(_selectedDay, normalizedToday) &&
                        widget.meditationCompletedToday &&
                        widget.selectedEmotion != null &&
                        widget.meditationThemeName != null) ...[
                      Text(
                        'Seçilen gün: ${_selectedDay!.toLocal().toIso8601String().split('T')[0]}\n'
                            '${widget.meditationThemeName}\n'
                            'Duygu: ${widget.selectedEmotion}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ]
                    else if (_selectedDay != null) ...[
                        Text(
                          'Seçilen gün: ${_selectedDay!.toLocal().toIso8601String().split('T')[0]}\n'
                              'Bu güne ait meditasyon bulunamadı.',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ]
                      else ...[
                          Text(
                            'Bir tarih seçin veya meditasyon yapın!',
                            style: const TextStyle(fontSize: 16, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}