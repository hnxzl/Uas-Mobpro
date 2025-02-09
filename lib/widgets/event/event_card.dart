import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format tanggal
import 'package:tododo/models/event_models.dart';

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.event, color: Colors.white),
        ),
        title: Text(event.title),
        subtitle: Text(
            '${event.location} - ${DateFormat.yMd().add_jm().format(event.eventTime)}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Implement delete action
          },
        ),
      ),
    );
  }
}
