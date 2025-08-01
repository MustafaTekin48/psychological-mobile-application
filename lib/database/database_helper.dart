import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "app_database.db");
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE scale_metadata (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_code TEXT UNIQUE NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        table_name TEXT NOT NULL,
        item_count INTEGER,
        min_score INTEGER,
        max_score INTEGER,
        has_level BOOLEAN DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE phq9 (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        score INTEGER,
        level TEXT,
        FOREIGN KEY(scale_id) REFERENCES scale_metadata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE beck_anxiety (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        score INTEGER,
        level TEXT,
        FOREIGN KEY(scale_id) REFERENCES scale_metadata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE beck_hopelessness (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        score INTEGER,
        level TEXT,
        FOREIGN KEY(scale_id) REFERENCES scale_metadata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE perceived_stress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        score INTEGER,
        level TEXT,
        note TEXT,
        FOREIGN KEY(scale_id) REFERENCES scale_metadata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE mental_wellbeing (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        score INTEGER,
        note TEXT,
        FOREIGN KEY(scale_id) REFERENCES scale_metadata(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE auth_users (
        user_id INTEGER PRIMARY KEY,
        email TEXT UNIQUE,
        password_hash TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE user_profile (
        profile_id INTEGER PRIMARY KEY,
        user_id INTEGER,
        age INTEGER,
        gender TEXT,
        height_cm REAL,
        weight_kg REAL,
        bmi REAL,
        FOREIGN KEY(user_id) REFERENCES auth_users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE daily_data (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        date TEXT,
        sleep_hours REAL,
        cigarettes INTEGER,
        alcohol_units INTEGER,
        water_intake REAL,
        FOREIGN KEY(user_id) REFERENCES auth_users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE weekly_data (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        week_start_date TEXT,
        strenuous_exercise INTEGER,
        moderate_exercise INTEGER,
        light_exercise INTEGER,
        weekly_cigarettes INTEGER,
        weekly_alcohol_units INTEGER,
        exercise_score REAL,
        FOREIGN KEY(user_id) REFERENCES auth_users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE monthly_data (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        month TEXT,
        systolic_pressure REAL,
        diastolic_pressure REAL,
        blood_sugar REAL,
        pulse_rate REAL,
        body_weight REAL,
        FOREIGN KEY(user_id) REFERENCES auth_users(user_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE diary_entries (
        id INTEGER PRIMARY KEY,
        user_id INTEGER,
        date TEXT,
        emotion TEXT,
        reason TEXT,
        rating INTEGER,
        FOREIGN KEY(user_id) REFERENCES auth_users(user_id)
      )
    ''');

    // ✅ EKLENEN TABLO
    await db.execute('''
      CREATE TABLE user_details (
        email TEXT PRIMARY KEY,
        age INTEGER,
        gender TEXT
      )
    ''');
  }
}
