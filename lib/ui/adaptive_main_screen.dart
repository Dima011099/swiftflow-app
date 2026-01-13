import 'package:flutter/material.dart';
import 'package:swift_flow/controllers/task_controller.dart';
import 'package:swift_flow/models/task.dart';
import 'package:swift_flow/ui/project_screen.dart';
import 'package:swift_flow/ui/widgets/project_list.dart';

import '../database_helper.dart';

class AdaptiveMainScreen extends StatefulWidget {
  const AdaptiveMainScreen({super.key});

  @override
  State<AdaptiveMainScreen> createState() => _AdaptiveMainScreenState();
}

class _AdaptiveMainScreenState extends State<AdaptiveMainScreen> {
  Project? _selectedProject;

  late final TaskController controller;

  bool get isMobile => MediaQuery.of(context).size.width < 900;

    @override
  void initState() {
    super.initState();
    controller = TaskController(DatabaseHelper.instance)..loadProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои Проекты'), backgroundColor: Colors.white),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, constraints) {
          if (!isMobile) {
            // ДЕСКТОП: 2 или 3 колонки
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: ProjectList(onProjectSelected: (p) => setState(() => _selectedProject = p), projects: controller.projects,),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _selectedProject != null
                      ? ProjectScreen() //TaskView(project: _selectedProject!)
                      : const Center(child: Text('Выберите проект слева')),
                ),
              ],
            );
          } else {
            // МОБИЛЬНЫЕ: Список с переходом
            return ProjectList(projects: controller.projects,
              onProjectSelected: (p) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                  ProjectScreen()
                  )  
                );
              },
            );
          }
        },
      ),
    );
  }
}