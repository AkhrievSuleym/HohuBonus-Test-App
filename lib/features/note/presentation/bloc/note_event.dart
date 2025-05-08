part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NoteUploadEvent extends NoteEvent {
  final String title;
  final String content;
  final File? image;

  NoteUploadEvent({
    required this.title,
    required this.content,
    required this.image,
  });
}

final class GetAllNotesEvent extends NoteEvent {}
