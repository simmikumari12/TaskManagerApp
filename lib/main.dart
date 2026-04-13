import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'models/task.dart';
import 'services/task_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Phase F: Dark Mode Support
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: Colors.blue),
      themeMode: ThemeMode.system, 
      home: const TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();

  void _showSubtaskDialog(Task task) {
    final subController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Subtask"),
        content: TextField(controller: subController, decoration: const InputDecoration(hintText: "Subtask name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            _taskService.addSubtask(task, subController.text);
            Navigator.pop(context);
          }, child: const Text("Add")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Manager Elite"), centerTitle: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _taskController, decoration: const InputDecoration(labelText: "What needs to be done?"))),
                const SizedBox(width: 8),
                IconButton(icon: const Icon(Icons.add_circle, size: 40), onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    _taskService.addTask(_taskController.text);
                    _taskController.clear();
                  }
                }),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Task>>(
              stream: _taskService.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No tasks! Add one to start. 🚀"));

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final task = snapshot.data![index];
                    return ExpansionTile(
                      leading: Checkbox(value: task.isCompleted, onChanged: (_) => _taskService.toggleTask(task)),
                      title: Text(task.title, style: TextStyle(decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.add_task), onPressed: () => _showSubtaskDialog(task)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _taskService.deleteTask(task.id)),
                        ],
                      ),
                      children: task.subtasks.map((sub) => ListTile(
                        contentPadding: const EdgeInsets.only(left: 64),
                        title: Text(sub['title']),
                        leading: const Icon(Icons.subdirectory_arrow_right, size: 18),
                      )).toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}