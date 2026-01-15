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

    return await openDatabase(path, version: 1, onCreate: _createDB, onOpen: (db) async {await db.execute('PRAGMA foreign_keys = ON');});

   
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE projects (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL
      )
    ''');

    await db.execute('''
        CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        project_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        status INTEGER NOT NULL, -- 0: Задачи, 1: В работе, 2: Результат
        difficulty INTEGER NOT NULL DEFAULT 1, -- Сложность (1-3)
        created_at TEXT NOT NULL,            -- Дата создания
        FOREIGN KEY (project_id) REFERENCES projects (id) ON DELETE CASCADE
        )
    ''');
  }

  Future<List<Map<String, dynamic>>> readAllTasks() async {
    final db = await instance.database;
    return await db.query('tasks');
  }

  Future<List<Map<String, dynamic>>> readAllTasksWhereProjectID(int projectID) async {
    final db = await instance.database;
    return db.query(
      'tasks',
      where: 'project_id = ?',
      whereArgs: [projectID],
    );
  }

  Future<List<Map<String, dynamic>>> readAllProjects() async {
    final db = await instance.database;
    return await db.query('projects');
  }

   Future<int> createProject (String title) async {
     final db = await instance.database;
     return await db.insert('projects', {'name': title});
   }

  Future<int> createTask(String title, int projectID) async {
    final db = await instance.database;
  //  return await db.insert('tasks', {'title': title, 'status': 0});


    return await db.insert('tasks', {
      'title': title,
      'status': 0,
      'difficulty': 1,
      'project_id': projectID,
      'created_at': DateTime.now().toIso8601String() // Формат: 2026-01-10T22:30...
    });
  }

  Future<int> updateTaskStatus(int id, int status) async {
    final db = await instance.database;
    return await db.update('tasks', {'status': status}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }


  Future<int> deleteProject(int id) async {
    final db = await instance.database;
    return await db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }
}