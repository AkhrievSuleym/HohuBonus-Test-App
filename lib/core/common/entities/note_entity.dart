class NoteEntity {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime updatedAt;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.updatedAt,
  });
}
