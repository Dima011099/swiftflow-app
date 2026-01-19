import 'package:flutter/material.dart';
import 'package:swift_flow/controllers/task_controller.dart';
import 'package:swift_flow/models/task.dart';
import 'package:swift_flow/ui/widgets/base_project_tile.dart';


class ProjectList extends StatelessWidget {
  final Function(Project) onProjectSelected;
  final Function(int) onProjectDeleted;
  final Function(int, String) onProjectUpdate;
  final Function(int) onExport;


 // List<Project> projects;

  final TaskController controller;


  ProjectList({
    required this.onProjectSelected,
    required this.onProjectDeleted,
    required this.controller,
    required this.onProjectUpdate,
    required this.onExport,
   });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.projects.length,
      itemBuilder: (context, index) => BaseProjectTile(
        title: controller.projects[index].name, 
        onTap: () => onProjectSelected(controller.projects[index]),
        onDelete: ()
          {
            onProjectDeleted(controller.projects[index].id); 
            controller.deleteProject(controller.projects[index].id);
          },
        onUpdate: onProjectUpdate,
        onExport: onExport,
        projectId: controller.projects[index].id,
        ),
    );
  }
}