import 'package:flutter/material.dart';
import 'package:swift_flow/ui/task_column.dart';
import '../controllers/task_controller.dart';
import '../database_helper.dart';
import '../models/task.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  late final TaskController controller;
  final TextEditingController input = TextEditingController();

  bool get isMobile => MediaQuery.of(context).size.width < 900;

  @override
  void initState() {
    super.initState();
    controller = TaskController(DatabaseHelper.instance)..load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return isMobile ? _mobile() : _desktop();
      },
    );
  }

  Widget _desktop() {
    return Scaffold(
      appBar: AppBar(title: const Text('SwiftFlow Desktop'), backgroundColor: Colors.white,),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: TaskStatus.values.map((status) {
            return Expanded(
              child: TaskColumn(
                status: status,
                tasks: controller.byStatus(status),
                onMove: controller.move,
                onDelete: controller.delete,
                draggable: true,
              ),
            );
          }).toList(),
        ),
      ),
      floatingActionButton: _fab(),
    );
  }

  Widget _mobile() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SwiftFlow'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ЗАДАЧИ'),
              Tab(text: 'В РАБОТЕ'),
              Tab(text: 'ГОТОВО'),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: TabBarView(
          children: TaskStatus.values.map((status) {
            return TaskColumn(
              status: status,
              tasks: controller.byStatus(status),
              onMove: controller.move,
              onDelete: controller.delete,
              draggable: false,
            );
          }).toList(),
        ),
        floatingActionButton: _fab(),
      ),
    );
  }

  Widget _fab() => FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Новая задача'),
            content: TextField(controller: input, autofocus: true),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
              ElevatedButton(
                onPressed: () {
                  controller.add(input.text);
                  input.clear();
                  Navigator.pop(context);
                },
                child: const Text('Добавить'),
              ),
            ],
          ),
        ),
      );
}
