import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_test_app/core/usecases/usecase.dart';
import 'package:hb_test_app/features/note/domain/usecases/get_all_notes.dart';
import 'package:hb_test_app/features/note/domain/usecases/upload_note.dart';
import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:meta/meta.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final UploadNote _uploadNote;
  final GetAllNotes _getAllNotes;

  NoteBloc({
    required UploadNote uploadNote,
    required GetAllNotes getAllNotes,
  })  : _uploadNote = uploadNote,
        _getAllNotes = getAllNotes,
        super(NoteInitial()) {
    on<NoteEvent>((event, emit) {
      emit(NoteLoading());
    });
    on<NoteUploadEvent>(_onNoteUpload);
    on<GetAllNotesEvent>(_onGetAllNotes);
  }

  void _onNoteUpload(NoteUploadEvent event, Emitter<NoteState> emit) async {
    final res = await _uploadNote(
      UploadNoteParams(
        title: event.title,
        content: event.content,
        image: event.image,
      ),
    );

    res.fold(
      (failure) => emit(NoteFailure(failure.message)),
      (note) => emit(NoteUploadSuccess()),
    );
  }

  void _onGetAllNotes(GetAllNotesEvent event, Emitter<NoteState> emit) async {
    final res = await _getAllNotes(EmptyParams());

    res.fold(
      (failure) => emit(NoteFailure(failure.message)),
      (notes) => emit(NoteDisplaySuccess(notes)),
    );
  }
}
