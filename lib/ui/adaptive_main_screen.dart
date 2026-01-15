import 'package:flutter/material.dart';
import 'package:swift_flow/controllers/task_controller.dart';
import 'package:swift_flow/models/task.dart';
import 'package:swift_flow/ui/project_screen.dart';
import 'package:swift_flow/ui/widgets/empty_task_widget.dart';
import 'package:swift_flow/ui/widgets/project_list.dart';

import '../database_helper.dart';

class AdaptiveMainScreen extends StatefulWidget {
  const AdaptiveMainScreen({super.key});

  @override
  State<AdaptiveMainScreen> createState() => _AdaptiveMainScreenState();
}

class _AdaptiveMainScreenState extends State<AdaptiveMainScreen> {
  Project? _selectedProject;

   final TextEditingController input = TextEditingController();

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
      appBar: AppBar(
        toolbarHeight: 72,
        leadingWidth: 72,
        actionsPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        title: const Text('Swift Flow - Projects'), 
        backgroundColor: Colors.white,
         actions: [
    IconButton(
    icon: const Icon(Icons.add), 
    onPressed: () {
      _addProject();
    },
  ),
  IconButton(
    icon: const Icon(Icons.person_sharp), 
    onPressed: () {
    },
  ),
   IconButton(
    icon: const Icon(Icons.settings),
    onPressed: () {
    },
  ),
],
      
        ),
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, constraints) {
          if (!isMobile) {
            // ДЕСКТОП: 2 или 3 колонки
            return Row(
              children: [
                SizedBox(
                  width: 300,
                  child: ProjectList(onProjectSelected: (p) => setState(() => _selectedProject = p), controller: controller, 
                  onProjectDeleted: (deletedId) {
                    if (_selectedProject?.id == deletedId) {
                      setState(() => _selectedProject = null);
                    }
                  },                
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: _selectedProject != null
                      ? ProjectScreen(projectID: _selectedProject!.id,) //TaskView(project: _selectedProject!)
                      : const Center(child: EmptyTasksWidget()),
                ),
              ],
            );
          } else {
            // МОБИЛЬНЫЕ: Список с переходом
            return ProjectList(controller: controller,
            onProjectDeleted:  (deletedId) {
                    if (_selectedProject?.id == deletedId) {
                      setState(() => _selectedProject = null);
                    }
                  },                
              onProjectSelected: (p) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                  ProjectScreen(projectID: p.id,)
                  )  
                );
              },
            );
          }
        },
      ),
    );
  }

  Future _addProject(){
    return showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Create a new project'),
            content: TextField(controller: input, autofocus: true),
            actions: [
              TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
              ElevatedButton(
                onPressed: () {
                  controller.addProject(input.text);
                  input.clear();
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
  }
}