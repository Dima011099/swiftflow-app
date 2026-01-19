import 'package:flutter/material.dart';
import 'package:swift_flow/ui/task_column.dart';
import '../controllers/task_controller.dart';
import '../database_helper.dart';
import '../models/task.dart';

class ProjectScreen extends StatefulWidget {
  final int projectID;

  const ProjectScreen({
    super.key,
    required this.projectID,
    });

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
    controller = TaskController(DatabaseHelper.instance)
      ..projectID = widget.projectID
      ..load();
  }

  @override
void didUpdateWidget(covariant ProjectScreen oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (widget.projectID != oldWidget.projectID) {
    controller.projectID = widget.projectID;
    controller.load(); // Перезагружаем данные при смене ID
  }
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
      appBar: AppBar(title: const Text('Base Project'), backgroundColor: Colors.white,),
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
                onUpdate: controller.updateTask,
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
          toolbarHeight: 72,
          leadingWidth: 72,
          actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          title: const Text('Base Project'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'TO DO'),
              Tab(text: 'IN PROGRESS'),
              Tab(text: 'DONE'),
            ],
          ),
          backgroundColor: Colors.white,
                 actions: [
    PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list), // Иконка фильтра
      onSelected: (String result) {
        // Логика фильтрации
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'date',
          child: Text('Date'),
        ),
        const PopupMenuItem<String>(
          value: 'low',
          child: Text('Low'),
        ),
         const PopupMenuItem<String>(
          value: 'hight',
          child: Text('Hight'),
        ),
      ],
    ),
  ],
        ),
        body: TabBarView(
          children: TaskStatus.values.map((status) {
            return TaskColumn(
              status: status,
              tasks: controller.byStatus(status),
              onMove: controller.move,
              onDelete: controller.delete,
              onUpdate: controller.updateTask,
              draggable: false,
            );
          }).toList(),
        ),
        floatingActionButton: _fab(),
      ),
    );
  }

  Widget _fab() => FloatingActionButton(
          elevation: 2,
          backgroundColor:  Colors.blue.shade500,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.all(Radius.circular(16)),
          ),
          child: const Icon(
          color: Colors.white,
          Icons.add_task_rounded,
          size: 24,
        ),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('New Task'),
            content: TextField(controller: input, autofocus: true),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
              ElevatedButton(
                onPressed: () {
                  controller.add(input.text);
                  input.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      );
}
