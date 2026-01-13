import 'package:flutter/material.dart';

class EmptyTasksWidget extends StatelessWidget {
  const EmptyTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withAlpha(18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.checklist_rounded,
                size: 36,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // Заголовок
            Text(
              'Задач пока нет',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

          
           Text('Добавтьте первую задачу, чтобы\n начать работу',
                        style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
    

             const SizedBox(height: 12),

            Text('Нажмите + внизу справа',
                        style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 15,
                color: Colors.blue.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}