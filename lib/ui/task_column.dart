import 'package:flutter/material.dart';
import 'package:swift_flow/ui/task_list.dart';
import '../models/task.dart';

class TaskColumn extends StatelessWidget {
  final TaskStatus status;
  final List<Task> tasks;
  final void Function(int, TaskStatus) onMove;
  final void Function(int) onDelete;
  final bool draggable;

  const TaskColumn({
    super.key,
    required this.status,
    required this.tasks,
    required this.onMove,
    required this.onDelete,
    required this.draggable,
  });

  bool isMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 900;
}


  @override
  Widget build(BuildContext context) {

    return DragTarget<int>(
      onAccept: (id) => onMove(id, status),
      builder: (_, candidate, __) {
        return Container(
          margin: (isMobileLayout(context)) ? EdgeInsets.all(0) : EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: candidate.isNotEmpty ? Colors.blue.withAlpha(10) : Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
          child: TaskList(
            tasks: tasks,
            draggable: draggable,
            onMove: onMove,
            onDelete: onDelete,
          ),
        );
      },
    );
  }
}
