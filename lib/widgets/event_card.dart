import 'package:flutter/material.dart';
import '../models/event_models.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final double distance;
  final VoidCallback onTap;

  const EventCard({
    super.key,
    required this.event,
    required this.distance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(event.name),
        subtitle: Text(
          '${event.location}\n${_formatDate(event.date)}',
        ),
        trailing: Text('${distance.toStringAsFixed(1)} km'),
        onTap: onTap,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
