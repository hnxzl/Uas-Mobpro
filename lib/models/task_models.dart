// Task Model
import 'package:supabase_flutter/supabase_flutter.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final bool isComplete;
  final String userId;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.isComplete,
    required this.userId,
    required this.createdAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isComplete: json['is_complete'] ?? false,
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'is_complete': isComplete,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

// Task Service
class TaskService {
  final SupabaseClient _supabase;
  static const String _tableName = 'tasks';

  TaskService(this._supabase);

  // Create a new task
  Future<Task> createTask(Task task) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(task.toJson())
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Get all tasks for a specific user
  Future<List<Task>> getTasksByUser(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }

  // Get task by ID
  Future<Task> getTaskById(String taskId) async {
    try {
      final response =
          await _supabase.from(_tableName).select().eq('id', taskId).single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get task: $e');
    }
  }

  // Update task
  Future<Task> updateTask(String taskId, Task task) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update(task.toJson())
          .eq('id', taskId)
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Toggle task completion status
  Future<Task> toggleTaskCompletion(String taskId, bool isComplete) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .update({'is_complete': isComplete})
          .eq('id', taskId)
          .select()
          .single();

      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to toggle task completion: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', taskId);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Get completed tasks
  Future<List<Task>> getCompletedTasks(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('is_complete', true)
          .order('created_at', ascending: false);

      return response.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get completed tasks: $e');
    }
  }

  // Get incomplete tasks
  Future<List<Task>> getIncompleteTasks(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .eq('is_complete', false)
          .order('created_at', ascending: false);

      return response.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get incomplete tasks: $e');
    }
  }
}
