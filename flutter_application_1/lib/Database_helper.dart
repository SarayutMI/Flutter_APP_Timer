import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('stats.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE stats (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      date TEXT,
      pomodoroCount INTEGER,
      startCount INTEGER,
      stopCount INTEGER,
      successCount INTEGER
    );
    ''');
  }

  Future<void> insertStat(Map<String, dynamic> stat) async {
    final db = await instance.database;
    await db.insert('stats', stat);
  }

  Future<List<Map<String, dynamic>>> getStatsByDate(String date) async {
    final db = await instance.database;
    return await db.query('stats', where: 'date = ?', whereArgs: [date]);
  }

  Future<List<Map<String, dynamic>>> getStatsByRange(String startDate, String endDate) async {
    final db = await instance.database;
    return await db.query('stats', where: 'date BETWEEN ? AND ?', whereArgs: [startDate, endDate]);
  }

  // ฟังก์ชันกรองข้อมูลตามเดือน (ใช้ strftime('%Y-%m', date))
  Future<List<Map<String, dynamic>>> getStatsByMonth(String yearMonth) async {
    final db = await instance.database;
    return await db.query('stats', where: "strftime('%Y-%m', date) = ?", whereArgs: [yearMonth]);
  }

  // ฟังก์ชันกรองข้อมูลตามปี (ใช้ strftime('%Y', date))
  Future<List<Map<String, dynamic>>> getStatsByYear(String year) async {
    final db = await instance.database;
    return await db.query('stats', where: "strftime('%Y', date) = ?", whereArgs: [year]);
  }
}
