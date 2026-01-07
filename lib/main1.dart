import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'dart:io'; 
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   // 1. Сначала проверяем, НЕ веб ли это
  if (!kIsWeb) {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }else{
    databaseFactory = databaseFactoryFfiWeb;
  }
  
  runApp(const SwiftFlowApp());
}


class SwiftFlowApp extends StatelessWidget {
  const SwiftFlowApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light),
      home: const ProjectScreen(),
    );
  }
}

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Desktop Columns')),
      body: Row(
        children: [
          Expanded(child: Container(color: Colors.red[100], child: const Center(child: Text("Колонка 1")))),
          Expanded(child: Container(color: Colors.green[100], child: const Center(child: Text("Колонка 2")))),
          Expanded(child: Container(color: Colors.blue[100], child: const Center(child: Text("Колонка 3")))),
        ],
      ),
    );
  }
}

class _ProjectScreenState extends State<ProjectScreen> {
  List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() async {
    final data = await DatabaseHelper.instance.readAllTasks();
    setState(() => _tasks = data);
  }

  void _addTask() async {
    if (_controller.text.isNotEmpty) {
      await DatabaseHelper.instance.createTask(_controller.text);
      _controller.clear();
      _refreshTasks();
    }
  }


 
  @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {

      if (!isMobileLayout(context)) {
        // Вид для ПК: три колонки в ряд
        return Scaffold(
          appBar: AppBar(title: const Text('SwiftFlow Desktop')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesktopColumn("ЗАДАЧИ", 0),
                const SizedBox(width: 16),
                _buildDesktopColumn("В РАБОТЕ", 1),
                const SizedBox(width: 16),
                _buildDesktopColumn("ГОТОВО", 2),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(),
            child: const Icon(Icons.add),
          ),
        );
      } else {
        // Вид для смартфона: вкладки (ваш текущий код)
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('SwiftFlow'),
              bottom: const TabBar(
                tabs: [Tab(text: 'ЗАДАЧИ'), Tab(text: 'В РАБОТЕ'), Tab(text: 'ГОТОВО')],
              ),
            ),
            body: TabBarView(
              physics: const BouncingScrollPhysics(parent: PageScrollPhysics()),
              children: [
                _buildTaskListView(0),
                _buildTaskListView(1),
                _buildTaskListView(2),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddDialog(),
              child: const Icon(Icons.add),
            ),
          ),
        );
      }
    },
  );
}


// Стилизованная колонка для десктопа
Widget _buildDesktopColumn(String title, int status) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black45),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(radius: 8, backgroundColor: Colors.black12, child: Text("3", style: TextStyle(fontSize: 9))),
              ],
            ),
          ),
          Expanded(child: _buildTaskList(status)),
        ],
      ),
    ),
  );
}


Widget _swipeBackground({
  required IconData icon,
  required String text,
  required Color color,
  required Alignment align,
}) {
  return Container(
    alignment: align,
    padding: const EdgeInsets.symmetric(horizontal: 24),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}


Widget _buildSwipeCard(Map<String, dynamic> task) {
  final int status = task['status'] ?? 0;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Dismissible(
      key: ValueKey('task_${task['id']}_$status'),
      // Свайп вправо (startToEnd) и влево (endToStart)
      direction: DismissDirection.horizontal,

      // Настраиваем фон в зависимости от текущего статуса
      background: status == 0 
          ? _swipeBackground(icon: Icons.play_arrow, text: "В РАБОТУ", color: Colors.orange, align: Alignment.centerLeft)
          : status == 1 
              ? //_swipeBackground(icon: Icons.assignment_return, text: "В ЗАДАЧИ", color: Colors.grey, align: Alignment.centerLeft)
              _swipeBackground(icon: Icons.check, text: "ГОТОВО", color: Colors.green, align: Alignment.centerLeft)
              : const SizedBox(), // Для статуса 2 (Готово) свайп вправо не нужен

      secondaryBackground: status == 1 
          ?// _swipeBackground(icon: Icons.check, text: "ГОТОВО", color: Colors.green, align: Alignment.centerRight)
          _swipeBackground(icon: Icons.assignment_return, text: "В ЗАДАЧИ", color: Colors.grey, align: Alignment.centerRight)
          : status == 0 
              ? const SizedBox() // С первой вкладки сразу в "Готово" обычно не прыгают
              : _swipeBackground(icon: Icons.replay, text: "ВЕРНУТЬ В РАБОТУ", color: Colors.orange, align: Alignment.centerRight),

      confirmDismiss: (direction) async {
        int newStatus = status;
        if (direction == DismissDirection.startToEnd && status < 2) newStatus++;
        if (direction == DismissDirection.endToStart && status > 0) newStatus--;

        if (newStatus != status) {
          await DatabaseHelper.instance.updateTaskStatus(task['id'], newStatus);
          _refreshTasks();
        }
        return false;
      },
      child: _cardBody(task),
    ),
  );
}


bool isMobileLayout(BuildContext context) {
  return MediaQuery.of(context).size.width < 900;
}


Widget _buildDraggableCard(Map<String, dynamic> task) {
  return LongPressDraggable<int>(
    data: task['id'],
    feedback: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 300,
        child: _cardBody(task),
      ),
    ),
    childWhenDragging: Opacity(opacity: 0.3, child: _cardBody(task)),
    child: _cardBody(task),
  );
}

Widget _cardBody(Map<String, dynamic> task) {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Верхний ряд: ID и Приоритет
        Row(
          children: [
            Text(
              "TASK-${task['id']}", // Уникальный номер задачи
              style: TextStyle(
                color: Colors.black38,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                fontFamily: 'Monospace', // Технический стиль
              ),
            ),
            const SizedBox(width: 12),
            _buildPriorityBadge(task['priority'] ?? 0),
            const Spacer(),
            IconButton(
              onPressed: () async {
                await DatabaseHelper.instance.deleteTask(task['id']);
                _refreshTasks();
              } 
            , 
            icon: const Icon(Icons.delete, size: 22, color: Colors.black26
            ),
            ),
             
          ],
        ),
        
        const SizedBox(height: 8),

        // Название задачи
        Text(
          task['title'],
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.2,
          ),
        ),

        const SizedBox(height: 12),

        // Нижний ряд: Мета-данные
        Row(
          children: [
            // Дедлайн (если есть в базе)
            Icon(Icons.calendar_today_outlined, size: 12, color: Colors.black45),
            const SizedBox(width: 4),
            Text(
              "24 Янв", 
              style: TextStyle(color: Colors.black45, fontSize: 12),
            ),
            const SizedBox(width: 16),
            // Исполнитель (аватар-заглушка)
            CircleAvatar(
              radius: 9,
              backgroundColor: Colors.blueGrey.shade100,
              child: const Text("A", style: TextStyle(fontSize: 9, color: Colors.white)),
            ),
            const Spacer(),
            // Тег статуса
            _buildStatusTag(task['status']),
          ],
        ),
      ],
    ),
    
  );
}

// Вспомогательный виджет для приоритета
Widget _buildPriorityBadge(int priority) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: priority > 0 ? Colors.red.withOpacity(0.1) : Colors.black.withOpacity(0.05),
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

// Вспомогательный виджет для статуса
Widget _buildStatusTag(int? status) {
  final List<String> labels = ["TO DO", "IN PROGRESS", "DONE"];
  final Color color = status == 2 ? Colors.green : (status == 1 ? Colors.blue : Colors.grey);
  
  return Text(
    labels[status ?? 0],
    style: TextStyle(
      color: color,
      fontSize: 10,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    ),
  );
}




Widget _buildTaskList(int status) {
  final filteredTasks = _tasks.where((t) => t['status'] == status).toList();
  
  return DragTarget<int>(
    onWillAcceptWithDetails: (data) => true,
    onAcceptWithDetails: (details) async { // Изменили имя параметра на 'details'
      final taskId = details.data; // Получаем само int значение
      await DatabaseHelper.instance.updateTaskStatus(taskId, status);
      _refreshTasks();
    },
    builder: (context, candidateData, rejectedData) {
      return Container(
        // Подсветка зоны, куда можно бросить карточку
        color: candidateData.isNotEmpty ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        child: filteredTasks.isEmpty 
          ? _buildEmptyState(status) // Если задач нет
          : _buildTaskListView(status),
     );
    },
  );
}

Widget _buildTaskListView(int status){
  final filteredTasks = _tasks.where((t) => t['status'] == status).toList();
  return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 80),
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) => (isMobileLayout(context)) ? 
                _buildSwipeCard(filteredTasks[index]):
                _buildDraggableCard(filteredTasks[index]),
            );
}

// Виджет для пустого списка
Widget _buildEmptyState(int status) {
  String message = status == 0 ? "Нет новых задач" : (status == 1 ? "Ничего не в работе" : "Список пуст");
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 60, color: Colors.grey.withOpacity(0.5)),
        const SizedBox(height: 16),
        Text(message, style: TextStyle(color: Colors.grey.withOpacity(0.8))),
      ],
    ),
  );
}

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новая задача'),
        content: TextField(controller: _controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          ElevatedButton(onPressed: () { _addTask(); Navigator.pop(context); }, child: const Text('Добавить')),
        ],
      ),
    );
  }
}