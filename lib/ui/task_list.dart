import 'package:flutter/material.dart';
import 'package:swift_flow/ui/task_card.dart';
import '../models/task.dart';
import 'swipe_card.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final bool draggable;
  final void Function(int, TaskStatus) onMove;
  final void Function(int) onDelete;

  const TaskList({
    super.key,
    required this.tasks,
    required this.draggable,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(child: Text('Пусто'));
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        return draggable
            ? TaskCard(task: tasks[i], draggable: draggable, onDelete: () =>  onDelete(tasks[i].id))
            : SwipeCard(task: tasks[i], onMove: onMove, onDelete: onDelete);
      },
    );
  }

  
}