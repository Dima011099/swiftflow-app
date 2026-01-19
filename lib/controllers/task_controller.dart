import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database_helper.dart';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';


import 'dart:io';

class TaskController extends ChangeNotifier {
  final DatabaseHelper db;
  List<Task> _tasks = [];

  List<Project> _projects = [];

  List<Task> get tasks => _tasks;

  List<Project> get projects => _projects;

  TaskController(this.db);

  int? _projectID;

  set projectID(int value) => _projectID = value;
  get projectID => _projectID;

  Future<void> load() async {
    //final data = await db.readAllTasks();
    final data = await db.readAllTasksWhereProjectID(_projectID!);
    _tasks = data.map(Task.fromMap).toList();
    notifyListeners();
  }

  Future<void> loadProjects() async {
    final data = await db.readAllProjects();
    _projects = data.map(Project.fromMap).toList();
    notifyListeners();
  }



  List<Task> byStatus(TaskStatus status) =>
      _tasks.where((t) => t.status == status).toList();

  Future<void> add(String title) async {
    await db.createTask(title, _projectID!);
    await load();
  }

  Future<void> updateTask(int id, String title) async{
    await db.updateTaskTitle(id, title);
    await load();
  }

  Future<void> updateProject(int id, String title) async{
    await db.updateProjectTitle(id, title);
    await loadProjects();
  }


  Future<void> exportJson(int id) async{
      final data = await db.readAllTasksWhereProjectID(id);
      String jsonString = jsonEncode(data);

        // Превращаем строку в байты
  Uint8List bytes = utf8.encode(jsonString);

  // Вызываем диалог сохранения файла
  String? outputFile = await FilePicker.platform.saveFile(
    dialogTitle: 'Выберите место для сохранения экспорта',
    fileName: 'project_export_$id.json',
    type: FileType.custom,
    allowedExtensions: ['json'],
    bytes: bytes, // Некоторые платформы (Web/Desktop) позволяют передать байты напрямую
  );

  if (outputFile != null) {
    print('Файл успешно сохранен: $outputFile');
  }
  }

  Future<void> importAsNewProject(String projectName) async {
  // 1. Выбираем файл
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['json'],
  );

  if (result == null || result.files.single.path == null) return;

  try {
    // 2. Читаем и парсим файл
    File file = File(result.files.single.path!);
    String content = await file.readAsString();
    List<dynamic> tasksData = jsonDecode(content);

    // 3. СОЗДАЕМ НОВЫЙ ПРОЕКТ в базе
    // Метод должен возвращать ID созданной записи (autoincrement)
    int newProjectId = await db.createProject(projectName);

    // 4. ПРИВЯЗЫВАЕМ ЗАДАЧИ к новому ID
    for (var item in tasksData) {
      Map<String, dynamic> taskMap = Map<String, dynamic>.from(item);
      
      // Удаляем старые ID, чтобы не было конфликтов
      taskMap.remove('id'); 
      
      // ПОДМЕНЯЕМ project_id на новый, который только что получили
      taskMap['project_id'] = newProjectId; 

      // Сохраняем задачу
      await db.insertTask(taskMap);
    }
  /*   try {
    final dbInstance = await db.database; // Получаем доступ к экземпляру sqflite

    // НАЧИНАЕМ ТРАНЗАКЦИЮ
    await dbInstance.transaction((txn) async {
      
      // 3. Создаем проект ВНУТРИ транзакции (используем txn.insert вместо db.createProject)
      int newProjectId = await txn.insert('projects', {
        'title': projectName,
        'created_at': DateTime.now().toIso8601String(),
      });

      // 4. Привязываем задачи
      for (var item in tasksData) {
        Map<String, dynamic> taskMap = Map<String, dynamic>.from(item);
        
        taskMap.remove('id'); 
        taskMap['project_id'] = newProjectId; 

        // ВАЖНО: передаем txn в ваш новый метод insertTask
        await db.insertTask(taskMap, txn: txn); 
      }
    });

    print("Импорт завершен успешно");
    loadProjects(); 
    
  } catch (e) {
    print("Ошибка импорта: $e"); // Если что-то пойдет не так, проект и задачи НЕ создадутся вообще
  }*/

    print("Импорт завершен. Новый проект ID: $newProjectId");
    loadProjects(); // Обновляем UI
    
  } catch (e) {
    print("Ошибка импорта: $e");
  }
}


  Future<void> addProject(String name) async {
    await db.createProject(name);
    await loadProjects();
  }

  Future<void> delete(int id) async {
    await db.deleteTask(id);
    await load();
  }

  Future<void> deleteProject(int id) async {
    await db.deleteProject(id);
    await loadProjects();
  }

  Future<void> move(int id, TaskStatus status) async {
    await db.updateTaskStatus(id, status.index);
    await load();
  }
}