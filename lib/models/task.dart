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
