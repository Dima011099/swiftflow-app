enum TaskStatus { todo, inProgress, done }

class Task {
  final int id;
  final String title;
  final TaskStatus status;
  final int priority;

  Task({
    required this.id,
    required this.title,
    required this.status,
    required this.priority,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      status: TaskStatus.values[map['status']],
      priority: map['priority'] ?? 0,
    );
  }
}

class Project {
  final int id;
  final String name;
 /* final List<Task> tasks;*/

  Project({
    required this.id,
    required this.name, 
   /* required this.tasks*/
  });

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
     /* tasks: (map['tasks'] as List<dynamic>?)
            ?.map((taskMap) => Task.fromMap(taskMap as Map<String, dynamic>))
            .toList() ?? [],*/
    );
  }
}
/*
// Фейковые данные
final List<Project> demoProjects = [
  Project(id:1, name: 'Сайт компании', tasks:
    [
      Task(id: 1, title: 'Дизайн', status: TaskStatus.done, priority: 1), 
      Task(id: 2, title: 'Верстка', status: TaskStatus.todo, priority: 2)
    ]),
  Project(id: 2, name: 'Мобильное приложение', tasks: 
    [
      Task(id: 3, title: 'API', status: TaskStatus.todo, priority: 1), 
      Task(id: 4, title: 'Авторизация', status: TaskStatus.inProgress, priority: 2)
    ]),
];*/