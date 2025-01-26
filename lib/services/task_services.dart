import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/task_models.dart';

class TaskService {
  final SupabaseClient _supabase;
  static const String _tableName = 'tasks';

  TaskService(this._supabase);

  Future<Task> createTask(Task task) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(task.toJson())
          .select()
          .single();
      return Task.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: \$e');
    }
  }

  Future<List<Task>> getTasksByUser(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response.map((json) => Task.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: \$e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', taskId);
    } catch (e) {
      throw Exception('Failed to delete task: \$e');
    }
  }
}
