import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_models.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  Future<List<Event>> fetchEvents(String userId) async {
    final response = await _supabase
        .from('events')
        .select()
        .eq('user_id', userId)
        .order('event_time', ascending: true);

    // ignore: unnecessary_type_check
    if (response is List == true) {
      throw Exception('Error fetching events.');
    }

    return (response as List).map((event) => Event.fromJson(event)).toList();
  }

  Future<void> createEvent(Event event) async {
    final response = await _supabase.from('events').insert(event.toJson());
    if (response == null) {
      throw Exception('Error creating event.');
    }
  }

  Future<void> updateEvent(Event event) async {
    final response = await _supabase
        .from('events')
        .update(event.toJson())
        .eq('id', event.id);
    if (response == null) {
      throw Exception('Error updating event.');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await _supabase.from('events').delete().eq('id', eventId);
    if (response == null) {
      throw Exception('Error deleting event.');
    }
  }
}
