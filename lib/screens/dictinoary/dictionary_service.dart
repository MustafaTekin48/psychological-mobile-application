import 'dart:convert';
import 'package:flutter/services.dart';
import 'database_helper.dart';

class DictionaryService {
  Future<void> loadCSVData() async {
    final db = DatabaseHelper();

    // CSV dosyasını oku
    final String response = await rootBundle.loadString('assets/data/dict1.csv');
    final List<dynamic> data = const LineSplitter().convert(response);

    // Veritabanına terimleri ekle
    for (var line in data) {
      List<String> values = line.split(',');
      if (values.length == 2) {
        String term = values[0].trim();
        String definition = values[1].trim();
        await db.insertTerm(term, definition);
      }

    }

  }

}



