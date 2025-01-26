import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tododo/widgets/add_event_widgets.dart';
import 'package:tododo/widgets/event_details_dialog.dart';
import '../widgets/event_card.dart';
import '../models/event_models.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final LatLng _currentLocation = const LatLng(37.7749, -122.4194);
  final Distance _distance = const Distance();
  List<Event> _events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      final response = await _supabase
          .from('events')
          .select()
          .order('date', ascending: true);

      if (!mounted) return;

      setState(() {
        _events =
            (response as List).map((data) => Event.fromJson(data)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  List<Event> get _filteredEvents {
    return _events
        .where((event) => isSameDay(event.date, _selectedDay))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildCalendar(),
                _buildMap(),
                _buildEventsList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2000),
      lastDay: DateTime.utc(2100),
      calendarFormat: CalendarFormat.month,
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        return _events.where((event) => isSameDay(event.date, day)).toList();
      },
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: _currentLocation,
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: _events.map((event) {
              return Marker(
                point: event.coordinates,
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _filteredEvents.length,
        itemBuilder: (context, index) {
          final event = _filteredEvents[index];
          return EventCard(
            event: event,
            distance: _distance.as(
              LengthUnit.Kilometer,
              _currentLocation,
              event.coordinates,
            ),
            onTap: () => _showEventDetails(event),
          );
        },
      ),
    );
  }

  Future<void> _showAddEventDialog() async {
    final result = await showDialog<Event>(
      context: context,
      builder: (context) => const AddEventDialog(),
    );

    if (result != null && mounted) {
      try {
        await _supabase.from('events').insert(result.toJson());
        await _fetchEvents();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding event: $e')),
        );
      }
    }
  }

  void _showEventDetails(Event event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(event: event),
    );
  }
}
