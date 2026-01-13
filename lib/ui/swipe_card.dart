import 'package:flutter/material.dart';
import 'package:swift_flow/ui/widgets/ui_card.dart';
import '../models/task.dart';

class SwipeCard extends StatelessWidget {
  final Task task;
  final void Function(int, TaskStatus) onMove;
  final void Function(int) onDelete;

  const SwipeCard({
    super.key,
    required this.task,
    required this.onMove,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final card = TaskCardView(
      task: task,
      onDelete: () => onDelete(task.id),
    );


  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      child: Dismissible(
        key: ValueKey('task_${task.id}_${task.status}'),
        direction: DismissDirection.horizontal,

        background: _leftBackground(),
        secondaryBackground: _rightBackground(),

        confirmDismiss: (direction) async {
          final newStatus = _nextStatus(direction);
          if (newStatus != null) {
            onMove(task.id, newStatus);
          }
          return false;
        },

        child: card,
      ),
    );
  }

  // ---------- ЛОГИКА ----------

  TaskStatus? _nextStatus(DismissDirection dir) {
    if (dir == DismissDirection.startToEnd) {
      if (task.status == TaskStatus.todo) return TaskStatus.inProgress;
      if (task.status == TaskStatus.inProgress) return TaskStatus.done;
    }

    if (dir == DismissDirection.endToStart) {
      if (task.status == TaskStatus.inProgress) return TaskStatus.todo;
      if (task.status == TaskStatus.done) return TaskStatus.inProgress;
    }

    return null;
  }

  // ---------- ФОНЫ ----------

  Widget _leftBackground() {
    if (task.status == TaskStatus.todo) {
      return _swipeBg(Icons.play_arrow, "IN PROGRESS", Colors.orange, Alignment.centerLeft);
    }
    if (task.status == TaskStatus.inProgress) {
      return _swipeBg(Icons.check, "DONE", Colors.green, Alignment.centerLeft);
    }
    return const SizedBox();
  }

  Widget _rightBackground() {
    if (task.status == TaskStatus.inProgress) {
      return _swipeBg(Icons.assignment_return, "TO DO", Colors.grey, Alignment.centerRight);
    }
    if (task.status == TaskStatus.done) {
      return _swipeBg(Icons.replay, "IN PROGRESS", Colors.orange, Alignment.centerRight);
    }
    return const SizedBox();
  }

  Widget _swipeBg(
    IconData icon,
    String text,
    Color color,
    Alignment align,
  ) {
    return Container(
      alignment: align,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}