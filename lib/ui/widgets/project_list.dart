import 'package:flutter/material.dart';
import 'package:swift_flow/models/task.dart';


class ProjectList extends StatelessWidget {
  final Function(Project) onProjectSelected;
  final List<Project> projects;

  ProjectList({required this.onProjectSelected, required this.projects });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: projects.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(projects[index].name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => onProjectSelected(projects[index]),
      ),
    );
  }
}