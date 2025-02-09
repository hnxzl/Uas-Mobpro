import 'package:url_launcher/url_launcher.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime eventTime;
  final String userId;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.eventTime,
    required this.userId,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        location: json['location'],
        eventTime: DateTime.parse(json['event_time']),
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'event_time': eventTime.toIso8601String(),
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
      };

  /// Membuka lokasi di Google Maps
  Future<void> openLocationInGoogleMaps() async {
    final Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}');
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not open location in Google Maps';
    }
  }
}
