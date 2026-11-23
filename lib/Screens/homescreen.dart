
import 'package:flutter/material.dart';

import '../models/task.dart';
import 'add_task_screen.dart';
import 'services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;

  const HomeScreen({
    super.key,
    required this.token,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // LOAD TASKS FROM MYSQL
  Future<void> loadTasks() async {
    try {
      final data = await ApiService.getTasks(widget.token);

      final loadedTasks = data.map((item) {
        return Task(
          title: item["title"] ?? "",
          description: item["description"] ?? "",
          dueDate: DateTime.parse(item["due_date"]),
          priority: item["priority"] ?? "Medium",
        );
      }).toList();

      if (!mounted) return;

      setState(() {
        tasks = loadedTasks;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Loading error: $e")),
      );
    }
  }

  // OPEN ADD TASK SCREEN
  Future<void> openAddTask() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          onSave: (task) async {
            // SAVE TASK IN MYSQL
            await ApiService.addTask(
              title: task.title,
              description: task.description,
              dueDate: task.dueDate,
              priority: task.priority,
              token: widget.token,
            );
          },
        ),
      ),
    );

    // REFRESH TASKS AFTER SAVING
    if (mounted) {
      await loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tash Viewer"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: loadTasks,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : tasks.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.visibility,
              color: Colors.blue,
              size: 80,
            ),
            SizedBox(height: 20),
            Text(
              "Welcome to Tash Viewer!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text("Login Successful"),
            SizedBox(height: 10),
            Text("No Tasks Added Yet"),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.task_alt,
                color: Colors.blue,
              ),
              title: Text(task.title),
              subtitle: Text(
                "${task.description}\nPriority: ${task.priority}",
              ),
              trailing: Text(
                "${task.dueDate.day}/"
                    "${task.dueDate.month}/"
                    "${task.dueDate.year}",
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddTask,
        backgroundColor: const Color(0xFF2878F0),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
