import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DiaryDatabase {
  static final DiaryDatabase instance = DiaryDatabase._init();
  static Database? _database;

  DiaryDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('diary.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    print("💾 [DATABASE INIT] Veritabanı yolu: $path");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("📌 [DATABASE CREATE] `_createDB()` çalışıyor... Tablo oluşturuluyor!");
        await _createDB(db, version);
      },
    );
  }



  Future<void> _createDB(Database db, int version) async {
    print("📌 `_createDB()` çalışıyor... Tablo oluşturuluyor!");

    await db.execute('''
    CREATE TABLE IF NOT EXISTS diary_entries (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT NOT NULL,
      emotion TEXT NOT NULL,
      reason TEXT NOT NULL,
      rating INTEGER NOT NULL
    )
  ''');

    print("✅ Tablo oluşturuldu!");
  }


  Future<int> addEntry(Map<String, dynamic> entry) async {
    final db = await instance.database;

    // **Önceden eklenmiş mi kontrol edelim**
    final existingEntries = await db.query(
      'diary_entries',
      where: 'date = ?',
      whereArgs: [entry['date']],
    );

    if (existingEntries.isNotEmpty) {
      print("⚠️ [DATABASE] Bu giriş zaten mevcut! Eklenmeyecek: $entry");
      return 0; // Zaten varsa ekleme yapma
    }

    print("📝 [DATABASE INSERT] Yeni giriş ekleniyor: $entry");
    final id = await db.insert('diary_entries', entry, conflictAlgorithm: ConflictAlgorithm.replace);
    print("✅ [DATABASE INSERT] Giriş eklendi: ID = $id");
    return id;
  }



  Future<List<Map<String, dynamic>>> getEntries() async {
    final db = await instance.database;
    print("📥 [DATABASE READ] Günlük kayıtları çekiliyor...");

    final entries = await db.query('diary_entries', orderBy: "date DESC");

    print("✅ [DATABASE READ] ${entries.length} kayıt bulundu!");

    return entries;
  }




  Future<int> updateEntry(int id, Map<String, dynamic> entry) async {
    final db = await instance.database;
    return await db.update(
      'diary_entries',
      entry,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteEntry(int id) async {
    final db = await instance.database;
    return await db.delete(
      'diary_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
