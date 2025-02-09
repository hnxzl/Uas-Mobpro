import 'package:flutter/material.dart';
import 'package:tododo/models/event_models.dart';
import 'event_card.dart';

class EventList extends StatelessWidget {
  final List<Event> events;

  const EventList({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        return EventCard(event: events[index]);
      },
    );
  }
}
