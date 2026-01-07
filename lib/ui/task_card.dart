import 'package:flutter/material.dart';
import 'package:swift_flow/models/task.dart';
import 'package:swift_flow/ui/widgets/ui_card.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool draggable;
  final VoidCallback onDelete;

 const TaskCard({
  super.key,
  required this.task,
  required this.draggable,
  required this.onDelete,
});

  @override
  Widget build(BuildContext context) {
   /* final card = _body();*/
    final card = TaskCardView(
      task: task,
      onDelete: onDelete,
    );

    if (!draggable) return card;

    return LongPressDraggable<int>(
      data: task.id,
      feedback: Material(child: SizedBox(width: 300, child: card)),
      childWhenDragging: Opacity(opacity: 0.3, child: card),
      child: card,
    );
  }


}