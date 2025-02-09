import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'note_card.dart';

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  late Future<List<dynamic>> notes;

  Future<List<dynamic>> _fetchNotes() async {
    try {
      final response = await Supabase.instance.client
          .from('notes') // Ganti dengan nama tabel Anda
          .select()
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        return [];
      }
      return response as List<dynamic>;
    } catch (error) {
      throw Exception('Failed to load notes: $error');
    }
  }

  void _deleteNote(int noteId) async {
    try {
      await Supabase.instance.client
          .from('notes') // Ganti dengan nama tabel Anda
          .delete()
          .eq('id', noteId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted successfully')),
      );

      // Refresh data
      setState(() {
        notes = _fetchNotes();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    notes = _fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: notes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notes found.'));
        }

        final notesData = snapshot.data!;

        return ListView.builder(
          itemCount: notesData.length,
          itemBuilder: (context, index) {
            final note = notesData[index];
            return NoteCard(
              title: note['title'] ?? 'Untitled',
              description: note['description'] ?? '',
              onDelete: () => _deleteNote(note['id']),
            );
          },
        );
      },
    );
  }
}
