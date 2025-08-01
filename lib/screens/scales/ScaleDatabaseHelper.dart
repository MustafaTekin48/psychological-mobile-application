import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ScaleDatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }
//////////////////////son halinde kaldır
  Future<void> resetDatabase() async {
    final db = await database;
    await _dropExistingTables(db); // Mevcut tabloları sil
    await _createTables(db); // Tabloları yeniden oluştur
    print("🔄 Veritabanı sıfırlandı.");
  }
  /////////////////////////////////////////

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'ScalesDB.db');
    print("📁 Veritabanı yolu: $path");

    if (!await File(path).exists()) {
      print("📂 Veritabanı dosyası bulunamadı, assets'ten kopyalanıyor...");
      await _copyDatabaseFromAssets(path);
    } else {
      print("📂 Veritabanı dosyası zaten mevcut.");
    }

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        print("🟢 Veritabanı oluşturuluyor...");
        await _createTables(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        print("🔄 Veritabanı güncelleniyor: $oldVersion -> $newVersion");
        if (oldVersion < 3) {
          await _dropExistingTables(db);
          await _createTables(db);
        }
      },
    );
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    try {
      final byteData = await rootBundle.load('assets/ScalesDB.db');
      final buffer = byteData.buffer.asUint8List();
      final file = File(path);
      await file.writeAsBytes(buffer);
      print("📂 Veritabanı assets klasöründen kopyalandı.");
    } catch (e) {
      print("⚠️ Veritabanı kopyalama hatası: $e");
    }
  }


  Future<void> _dropExistingTables(Database db) async {
    List<String> tables = [
      'beck_anxiety', 'beck_hopelessness', 'big_five', 'depressionTable',
      'edinburgh_wellbeing', 'perceived_stress', 'scales'
    ];
    for (String table in tables) {
      await db.execute('DROP TABLE IF EXISTS $table;');
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "scales" (
        scale_id INTEGER PRIMARY KEY AUTOINCREMENT,
        scale_name TEXT NOT NULL,
        description TEXT
      );
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS "beck_anxiety" (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      scale_id INTEGER DEFAULT 2,
      created_at TEXT NOT NULL DEFAULT (DATE('now')),
      question1 INTEGER,
      question2 INTEGER,
      question3 INTEGER,
      question4 INTEGER,
      question5 INTEGER,
      question6 INTEGER,
      question7 INTEGER,
      question8 INTEGER,
      question9 INTEGER,
      question10 INTEGER,
      question11 INTEGER,
      question12 INTEGER,
      question13 INTEGER,
      question14 INTEGER,
      question15 INTEGER,
      question16 INTEGER,
      question17 INTEGER,
      question18 INTEGER,
      question19 INTEGER,
      question20 INTEGER,
      total_score INTEGER,
      FOREIGN KEY(scale_id) REFERENCES scales(scale_id)
    );
  ''');


    await db.execute('''
CREATE TABLE IF NOT EXISTS "beck_hopelessness" (
	"id"	INTEGER,
	"scale_id"	INTEGER DEFAULT 3,
	"q1"	INTEGER,
	"q2"	INTEGER,
	"q3"	INTEGER,
	"q4"	INTEGER,
	"q5"	INTEGER,
	"q6"	INTEGER,
	"q7"	INTEGER,
	"q8"	INTEGER,
	"q9"	INTEGER,
	"q10"	INTEGER,
	"q11"	INTEGER,
	"q12"	INTEGER,
	"q13"	INTEGER,
	"q14"	INTEGER,
	"q15"	INTEGER,
	"q16"	INTEGER,
	"q17"	INTEGER,
	"q18"	INTEGER,
	"q19"	INTEGER,
	"q20"	INTEGER,
	"created_at"	TEXT DEFAULT (DATE('now')),
	"totalScore"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("scale_id") REFERENCES "scales"("scale_id")
);
    ''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS "big_five" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "scale_id" INTEGER DEFAULT 4,
  "q1" INTEGER,
  "q2" INTEGER,
  "q3" INTEGER,
  "q4" INTEGER,
  "q5" INTEGER,
  "q6" INTEGER,
  "q7" INTEGER,
  "q8" INTEGER,
  "q9" INTEGER,
  "q10" INTEGER,
  "q11" INTEGER,
  "q12" INTEGER,
  "q13" INTEGER,
  "q14" INTEGER,
  "q15" INTEGER,
  "q16" INTEGER,
  "q17" INTEGER,
  "q18" INTEGER,
  "q19" INTEGER,
  "q20" INTEGER,
  "q21" INTEGER,
  "q22" INTEGER,
  "q23" INTEGER,
  "q24" INTEGER,
  "q25" INTEGER,
  "q26" INTEGER,
  "q27" INTEGER,
  "q28" INTEGER,
  "q29" INTEGER,
  "q30" INTEGER,
  "q31" INTEGER,
  "q32" INTEGER,
  "q33" INTEGER,
  "q34" INTEGER,
  "q35" INTEGER,
  "q36" INTEGER,
  "q37" INTEGER,
  "q38" INTEGER,
  "q39" INTEGER,
  "q40" INTEGER,
  "q41" INTEGER,
  "q42" INTEGER,
  "q43" INTEGER,
  "q44" INTEGER,
  "q45" INTEGER,
  "q46" INTEGER,
  "q47" INTEGER,
  "q48" INTEGER,
  "q49" INTEGER,
  "q50" INTEGER,
  "created_at" TEXT DEFAULT (DATE('now')),
  "total_score" INTEGER,
  "extraversion" INTEGER,
  "agreeableness" INTEGER,
  "conscientiousness" INTEGER,
  "neuroticism" INTEGER,
  "openExperience" INTEGER,
  FOREIGN KEY("scale_id") REFERENCES "scales"("scale_id")
);
    ''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS "depressionTable" (
  "id" INTEGER PRIMARY KEY AUTOINCREMENT,
  "scale_id" INTEGER DEFAULT 1,
  "question1" INTEGER,
  "question2" INTEGER,
  "question3" INTEGER,
  "question4" INTEGER,
  "question5" INTEGER,
  "question6" INTEGER,
  "question7" INTEGER,
  "question8" INTEGER,
  "question9" INTEGER,
  "question10" INTEGER,
  "created_at" TEXT DEFAULT (DATE('now')),
  "total_score" INTEGER,
  FOREIGN KEY("scale_id") REFERENCES "scales"("scale_id")
);
    ''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS "edinburgh_wellbeing" (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  scale_id INTEGER DEFAULT 5,
  question1 INTEGER,
  question2 INTEGER,
  question3 INTEGER,
  question4 INTEGER,
  question5 INTEGER,
  question6 INTEGER,
  question7 INTEGER,
  created_at TEXT DEFAULT (DATE('now')),
  total_score INTEGER,
  FOREIGN KEY(scale_id) REFERENCES scales(scale_id)
);
    ''');

    await db.execute('''
CREATE TABLE IF NOT EXISTS "perceived_stress" (
	"id"	INTEGER,
	"scale_id"	INTEGER,
	"q1"	INTEGER,
	"q2"	INTEGER,
	"q3"	INTEGER,
	"q4"	INTEGER,
	"q5"	INTEGER,
	"q6"	INTEGER,
	"q7"	INTEGER,
	"q8"	INTEGER,
	"q9"	INTEGER,
	"q10"	INTEGER,
	"created_at"	TEXT DEFAULT (DATE('now')),
	"totalScore"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("scale_id") REFERENCES "scales"("scale_id")
);
    ''');

    print("✅ Tablolar başarıyla oluşturuldu.");
  }

  Future<List<Map<String, dynamic>>> getScaleResults(String scaleName) async {
    final db = await database;
    return await db.query(scaleName, orderBy: "created_at");
  }



  Future<int> insertEdinburg(List<int> answers) async {
    final db = await database;
    Map<String, dynamic> row = {
      'date': DateTime.now().toIso8601String(),
    };

    for (int i = 0; i < answers.length; i++) {
      row['q${i + 1}'] = answers[i];
    }

    return await db.insert('edinburgh_wellbeing', row);
  }




  Future<void> insertBeckAnxietyAnswers(
      int question1, int question2, int question3, int question4, int question5,
      int question6, int question7, int question8, int question9, int question10,
      int question11, int question12, int question13, int question14, int question15,
      int question16, int question17, int question18, int question19, int question20,
      int totalScore, String createdAt) async {

    final db = await database;

    await db.insert(
      'beck_anxiety',
      {
        'question1': question1,
        'question2': question2,
        'question3': question3,
        'question4': question4,
        'question5': question5,
        'question6': question6,
        'question7': question7,
        'question8': question8,
        'question9': question9,
        'question10': question10,
        'question11': question11,
        'question12': question12,
        'question13': question13,
        'question14': question14,
        'question15': question15,
        'question16': question16,
        'question17': question17,
        'question18': question18,
        'question19': question19,
        'question20': question20,
        'total_score': totalScore,
        'created_at': createdAt,  // Tarihi burada kaydediyoruz
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBeckHopelessnessAnswers(
      int question1, int question2, int question3, int question4, int question5,
      int question6, int question7, int question8, int question9, int question10,
      int question11, int question12, int question13, int question14, int question15,
      int question16, int question17, int question18, int question19, int question20,
      int totalScore, String createdAt) async {

    final db = await database;

    // Ters maddeler: 1, 3, 5, 6, 8, 10, 13, 15, 19
    question1 = 1 - question1; // Ters madde
    question3 = 1 - question3; // Ters madde
    question5 = 1 - question5; // Ters madde
    question6 = 1 - question6; // Ters madde
    question8 = 1 - question8; // Ters madde
    question10 = 1 - question10; // Ters madde
    question13 = 1 - question13; // Ters madde
    question15 = 1 - question15; // Ters madde
    question19 = 1 - question19; // Ters madde

    await db.insert(
      'beck_hopelessness',
      {
        'q1': question1,
        'q2': question2,
        'q3': question3,
        'q4': question4,
        'q5': question5,
        'q6': question6,
        'q7': question7,
        'q8': question8,
        'q9': question9,
        'q10': question10,
        'q11': question11,
        'q12': question12,
        'q13': question13,
        'q14': question14,
        'q15': question15,
        'q16': question16,
        'q17': question17,
        'q18': question18,
        'q19': question19,
        'q20': question20,
        'totalScore': totalScore,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  Future<void> insertDepressionAnswers(
      int question1, int question2, int question3, int question4, int question5,
      int question6, int question7, int question8, int question9, int question10,
      int totalScore, String createdAt) async {

    final db = await database;

    await db.insert(
      'depressionTable',
      {
        'question1': question1,
        'question2': question2,
        'question3': question3,
        'question4': question4,
        'question5': question5,
        'question6': question6,
        'question7': question7,
        'question8': question8,
        'question9': question9,
        'question10': question10,
        'total_score': totalScore,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertPerceivedStressAnswers(
      int question1, int question2, int question3, int question4, int question5,
      int question6, int question7, int question8, int question9, int question10,
      int totalScore, String createdAt) async {

    final db = await database;

    // Ters maddeler: 4, 5, 7, 8
    question4 = 4 - question4; // Ters madde
    question5 = 4 - question5; // Ters madde
    question7 = 4 - question7; // Ters madde
    question8 = 4 - question8; // Ters madde

    await db.insert(
      'perceived_stress',
      {
        'q1': question1,
        'q2': question2,
        'q3': question3,
        'q4': question4,
        'q5': question5,
        'q6': question6,
        'q7': question7,
        'q8': question8,
        'q9': question9,
        'q10': question10,
        'totalScore': totalScore,
        'created_at': createdAt,  // Tarihi burada kaydediyoruz
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertEdinburghWellbeingAnswers(
      int question1, int question2, int question3, int question4, int question5,
      int question6, int question7,
      int totalScore, String createdAt) async {

    final db = await database;

    await db.insert(
      'edinburgh_wellbeing',
      {
        'question1': question1,
        'question2': question2,
        'question3': question3,
        'question4': question4,
        'question5': question5,
        'question6': question6,
        'question7': question7,
        'total_score': totalScore,
        'created_at': createdAt,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<void> insertBigFiveAnswers(
      List<int> answers, int totalScore, String createdAt) async {
    final db = await database;

    // Faktör puanlarını hesapla
    final factorScores = calculateBigFiveScores(answers);

    await db.insert(
      'big_five',
      {
        'q1': answers[0],
        'q2': answers[1],
        'q3': answers[2],
        'q4': answers[3],
        'q5': answers[4],
        'q6': answers[5],
        'q7': answers[6],
        'q8': answers[7],
        'q9': answers[8],
        'q10': answers[9],
        'q11': answers[10],
        'q12': answers[11],
        'q13': answers[12],
        'q14': answers[13],
        'q15': answers[14],
        'q16': answers[15],
        'q17': answers[16],
        'q18': answers[17],
        'q19': answers[18],
        'q20': answers[19],
        'q21': answers[20],
        'q22': answers[21],
        'q23': answers[22],
        'q24': answers[23],
        'q25': answers[24],
        'q26': answers[25],
        'q27': answers[26],
        'q28': answers[27],
        'q29': answers[28],
        'q30': answers[29],
        'q31': answers[30],
        'q32': answers[31],
        'q33': answers[32],
        'q34': answers[33],
        'q35': answers[34],
        'q36': answers[35],
        'q37': answers[36],
        'q38': answers[37],
        'q39': answers[38],
        'q40': answers[39],
        'q41': answers[40],
        'q42': answers[41],
        'q43': answers[42],
        'q44': answers[43],
        'q45': answers[44],
        'q46': answers[45],
        'q47': answers[46],
        'q48': answers[47],
        'q49': answers[48],
        'q50': answers[49],
        'total_score': totalScore,
        'created_at': createdAt,
        'extraversion': factorScores['extraversion'],
        'agreeableness': factorScores['agreeableness'],
        'conscientiousness': factorScores['conscientiousness'],
        'neuroticism': factorScores['neuroticism'],
        'openExperience': factorScores['openness'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Map<String, int> calculateBigFiveScores(List<int> answers) {
    // Ters kodlanmış soruların indeksleri (0'dan başlayarak)
    final reversedQuestions = [25, 30, 35, 40, 45]; // Örnek: 26, 31, 36, 41, 46 (1'den başlayarak)

    // Faktör puanlarını hesapla
    int extraversion = 0;
    int agreeableness = 0;
    int conscientiousness = 0;
    int neuroticism = 0;
    int openness = 0;

    for (int i = 0; i < answers.length; i++) {
      int score = answers[i];
      if (reversedQuestions.contains(i)) {
        score = 6 - score; // Ters kodlama (5 puanlık ölçek için)
      }

      if (i < 10) extraversion += score;
      else if (i < 20) agreeableness += score;
      else if (i < 30) conscientiousness += score;
      else if (i < 40) neuroticism += score;
      else openness += score;
    }

    return {
      'extraversion': extraversion,
      'agreeableness': agreeableness,
      'conscientiousness': conscientiousness,
      'neuroticism': neuroticism,
      'openness': openness,
    };
  }


  Future<void> deleteDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'ScalesDB.db');
    await deleteDatabase();
    print("🗑️ Veritabanı silindi.");
  }






}