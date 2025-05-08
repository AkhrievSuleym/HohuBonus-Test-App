import 'dart:io';

import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/error/exceptions.dart';
import 'package:hb_test_app/core/error/failures.dart';
import 'package:hb_test_app/core/network/connection.dart';
import 'package:hb_test_app/features/note/data/datasources/note_local_data_source.dart';
import 'package:hb_test_app/features/note/data/datasources/note_remote_data_source.dart';
import 'package:hb_test_app/features/note/data/models/note_model.dart';
import 'package:hb_test_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource noteRemoteDataSource;
  final NoteLocalDataSource noteLocalDataSource;
  final ConnectionChecker connectionChecker;

  NoteRepositoryImpl(
    this.noteRemoteDataSource,
    this.noteLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failure, NoteEntity>> uploadNote({
    required File? image,
    required String title,
    required String content,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure('No internet connection'));
      }
      NoteModel noteModel = NoteModel(
        id: const Uuid().v1(),
        title: title,
        content: content,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );

      late final String imageUrl;
      if (image != null) {
        imageUrl = await noteRemoteDataSource.uploadNoteImage(
            image: image, note: noteModel);
      } else {
        imageUrl = '';
      }

      noteModel = noteModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadNote = await noteRemoteDataSource.uploadNote(noteModel);

      return right(uploadNote);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> getAllNotes() async {
    try {
      if (!await connectionChecker.isConnected) {
        final notes = noteLocalDataSource.loadNotes();
        return right(notes);
      }
      final notes = await noteRemoteDataSource.getAllNotes();
      noteLocalDataSource.uploadLocalNotes(notes: notes);
      return right(notes);
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }
}
