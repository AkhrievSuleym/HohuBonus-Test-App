part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteFailure extends NoteState {
  final String error;

  NoteFailure(this.error);
}

final class NoteUploadSuccess extends NoteState {}

final class NoteDisplaySuccess extends NoteState {
  final List<NoteEntity> notes;

  NoteDisplaySuccess(this.notes);
}
