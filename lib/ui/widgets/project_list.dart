import 'package:flutter/material.dart';
import 'package:swift_flow/models/task.dart';
import 'package:swift_flow/ui/widgets/base_project_tile.dart';


class ProjectList extends StatelessWidget {
  final Function(Project) onProjectSelected;
  final List<Project> projects;

  ProjectList({required this.onProjectSelected, required this.projects });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) => BaseProjectTile(
        title: projects[index].name, 
        onTap: () => onProjectSelected(projects[index]),
        ),
    );
  }
}