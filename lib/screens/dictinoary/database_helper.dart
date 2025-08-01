import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:csv/csv.dart';
import 'term.dart'; // Term modelini içe aktarın

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'psychology_dictionary.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE dictionary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            term TEXT,
            definition TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS dictionary');
        await db.execute(''' 
          CREATE TABLE dictionary(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            term TEXT,
            definition TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertTerm(String term, String definition) async {
    final db = await database;
    await db.insert(
      'dictionary',
      {'term': term, 'definition': definition},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getTerms() async {
    final db = await database;
    return await db.query('dictionary');
  }

  Future<void> loadCSVData() async {
    final String csvString = await rootBundle.loadString(
        'assets/data/dict1.csv');
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(
        csvString);
    for (var i = 1; i < csvTable.length; i++) { // Başlık satırını atla
      final row = csvTable[i];
      await insertTerm(row[0].toString(), row[1].toString());
    }
  }
}
