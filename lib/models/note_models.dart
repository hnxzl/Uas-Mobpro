import 'package:supabase_flutter/supabase_flutter.dart';

class Note {
  final String? id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
