import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'task_card.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? 'Untitled',
      description: json['description'],
      isCompleted: json['is_completed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late Future<List<Task>> tasks;

  Future<List<Task>> _fetchTasks() async {
    try {
      final response = await Supabase.instance.client
          .from('tasks')
          .select()
          .order('created_at', ascending: false);

      if (response == null) {
        return [];
      }

      return (response as List<dynamic>)
          .map((task) => Task.fromJson(task))
          .toList();
    } catch (error) {
      throw Exception('Failed to load tasks: $error');
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      await Supabase.instance.client.from('tasks').delete().eq('id', taskId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully')),
        );
      }

      // Refresh the task list
      setState(() {
        tasks = _fetchTasks();
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task: $error')),
        );
      }
    }
  }

  Future<void> _toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      await Supabase.instance.client
          .from('tasks')
          .update({'is_completed': !isCompleted}).eq('id', taskId);

      // Refresh the task list
      setState(() {
        tasks = _fetchTasks();
      });
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $error')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    tasks = _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: tasks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading tasks: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      tasks = _fetchTasks();
                    });
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final tasksList = snapshot.data ?? [];

        if (tasksList.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_outlined, size: 48, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tasks found.\nTry adding a new task!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: tasksList.length,
          itemBuilder: (context, index) {
            final task = tasksList[index];
            return TaskCard(
              name: task.title,
              description: task.description ?? '',
              isCompleted: task.isCompleted,
              onDelete: () => _deleteTask(task.id),
              onToggleComplete: () =>
                  _toggleTaskCompletion(task.id, task.isCompleted),
            );
          },
        );
      },
    );
  }
}
