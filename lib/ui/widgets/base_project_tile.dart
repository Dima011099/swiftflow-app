import 'package:flutter/material.dart';

class BaseProjectTile extends StatelessWidget {
  final int projectId;
  final String title;

  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Function(int, String) onUpdate;
  final Function(int) onExport; 
  
  final TextEditingController input = TextEditingController();
  

  BaseProjectTile({
    super.key,
    required this.title,
    this.onTap,
    this.onDelete,
    required this.onUpdate,
    required this.onExport,
    required this.projectId
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.08),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.dashboard_customize_rounded,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
             /* IconButton(onPressed: onDelete,
              icon: Icon(
                Icons.delete_outline,
                color: theme.iconTheme.color?.withOpacity(0.5),
                size: 20,
              ),),*/
                          PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20, color: Color.from(red: 0.3, blue: 0.1, green: 0.15, alpha: .5)), // Иконка фильтра
                  onSelected: (String result) {
                    switch(result){
                      case 'edit':
                        input.text = title;
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                          title: const Text('Edit Task'),
                          content: TextField(controller: input, autofocus: true),
                          actions: [
                            TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
                            ElevatedButton(
                            onPressed: () {
                             // controller.add(input.text);
                              onUpdate(projectId, input.text);
                              input.clear();
                              Navigator.pop(context);
                            },
                          child: const Text('Save'),
                        ),
                        ],
                      ),
                  );
                      break;
                      case 'delete':
                        onDelete!();
                      break;
                      case 'export':
                        onExport(projectId);
                      break;
                      case 'sync':

                      break;
                    }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                   const PopupMenuItem<String>(
                    value: 'sync',
                    child: Text('Sync'),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: Text('Expot'),
                  ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}