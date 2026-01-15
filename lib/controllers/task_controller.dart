import 'package:flutter/material.dart';
import '../models/task.dart';
import '../database_helper.dart';

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