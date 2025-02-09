import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_models.dart';

class TaskService {
  final _supabase = Supabase.instance.client;

  Future<List<Task>> fetchTasks(String userId) async {
    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (response == null || response is List == false) {
      throw Exception('Error fetching tasks.');
    }

    return (response as List).map((task) => Task.fromJson(task)).toList();
  }

  Future<void> createTask(Task task) async {
    final response = await _supabase.from('tasks').insert(task.toJson());
    if (response == null) {
      throw Exception('Error creating task.');
    }
  }

  Future<void> updateTask(Task task) async {
    final response =
        await _supabase.from('tasks').update(task.toJson()).eq('id', task.id);
    if (response == null) {
      throw Exception('Error updating task.');
    }
  }

  Future<void> deleteTask(String taskId) async {
    final response = await _supabase.from('tasks').delete().eq('id', taskId);
    if (response == null) {
      throw Exception('Error deleting task.');
    }
  }
}
