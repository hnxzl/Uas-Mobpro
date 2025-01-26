import 'package:latlong2/latlong.dart';

class Event {
  final String id;
  final String name;
  final DateTime date;
  final String location;
  final LatLng coordinates;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.coordinates,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      name: json['name'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      coordinates: LatLng(
        json['latitude'].toDouble(),
        json['longitude'].toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date.toIso8601String(),
      'location': location,
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
  }
}