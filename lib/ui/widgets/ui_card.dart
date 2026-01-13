import 'package:flutter/material.dart';
import 'package:swift_flow/models/task.dart';

class TaskCardView extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;

  const TaskCardView({
    super.key,
    required this.task,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Text(
                "TASK-${task.id}",
                style: const TextStyle(
                  color: Colors.black38,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Monospace',
                ),
              ),
              const SizedBox(width: 12),
              _priority(task.priority),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete, size: 20, color: Color.from(red: 0.3, blue: 0.1, green: 0.15, alpha: .5)),
                onPressed: onDelete,
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// TITLE
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 12),

          /// FOOTER
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 12, color: Colors.black45),
              const SizedBox(width: 4),
              const Text("24 Jan.", style: TextStyle(fontSize: 12, color: Colors.black45)),
              const SizedBox(width: 16),
              CircleAvatar(
                radius: 9,
                backgroundColor: Colors.blueGrey.shade100,
                child: const Text("A", style: TextStyle(fontSize: 9, color: Colors.white)),
              ),
              const Spacer(),
              _status(task.status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priority(int priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: priority > 0
            ? Colors.red.shade300
            : Colors.black12,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        priority > 0 ? "HIGH" : "LOW",
        style: TextStyle(
          color: priority > 0 ? Colors.red : Colors.black45,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _status(TaskStatus status) {
    const labels = {
      TaskStatus.todo: "TO DO",
      TaskStatus.inProgress: "IN PROGRESS",
      TaskStatus.done: "DONE",
    };

    final color = switch (status) {
      TaskStatus.todo => Colors.grey,
      TaskStatus.inProgress => Colors.blue,
      TaskStatus.done => Colors.green,
    };

    return Text(
      labels[status]!,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }
}