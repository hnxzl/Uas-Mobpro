import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_models.dart';

class NoteService {
  final SupabaseClient _supabase;
  static const String _tableName = 'notes';

  NoteService(this._supabase);

  Future<Note> createNote(Note note) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .insert(note.toJson())
          .select()
          .single();
      return Note.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create note: \$e');
    }
  }

  Future<List<Note>> getNotesByUser(String userId) async {
    try {
      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      return response.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get notes: \$e');
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _supabase.from(_tableName).delete().eq('id', noteId);
    } catch (e) {
      throw Exception('Failed to delete note: \$e');
    }
  }
}
