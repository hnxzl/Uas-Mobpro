import 'package:flutter/material.dart';
import '../models/event_models.dart';

class EventDetailsDialog extends StatelessWidget {
  final Event event;

  const EventDetailsDialog({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(event.name),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location: ${event.location}'),
          const SizedBox(height: 8),
          Text('Date: ${_formatDate(event.date)}'),
          const SizedBox(height: 8),
          Text(
            'Coordinates: ${event.coordinates.latitude}, ${event.coordinates.longitude}',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
