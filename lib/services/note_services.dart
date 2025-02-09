import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note_models.dart';

class NoteService {
  final _supabase = Supabase.instance.client;

  Future<List<Note>> fetchNotes(String userId) async {
    final response = await _supabase
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    if (response == null || response is List == false) {
      throw Exception('Error fetching notes.');
    }

    return (response as List).map((note) => Note.fromJson(note)).toList();
  }

  Future<void> createNote(Note note) async {
    final response = await _supabase.from('notes').insert(note.toJson());
    if (response == null) {
      throw Exception('Error creating note.');
    }
  }

  Future<void> updateNote(Note note) async {
    final response =
        await _supabase.from('notes').update(note.toJson()).eq('id', note.id);
    if (response == null) {
      throw Exception('Error updating note.');
    }
  }

  Future<void> deleteNote(String noteId) async {
    final response = await _supabase.from('notes').delete().eq('id', noteId);
    if (response == null) {
      throw Exception('Error deleting note.');
    }
  }
}
