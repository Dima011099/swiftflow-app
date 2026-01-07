import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        status INTEGER NOT NULL -- 0: Задачи, 1: В работе, 2: Результат
      )
    ''');
  }

  Future<List<Map<String, dynamic>>> readAllTasks() async {
    final db = await instance.database;
    return await db.query('tasks');
  }

  Future<int> createTask(String title) async {
    final db = await instance.database;
    return await db.insert('tasks', {'title': title, 'status': 0});
  }

  Future<int> updateTaskStatus(int id, int status) async {
    final db = await instance.database;
    return await db.update('tasks', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}