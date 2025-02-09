class Note {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
      };
}
