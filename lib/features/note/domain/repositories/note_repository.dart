import 'dart:io';

import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class NoteRepository {
  Future<Either<Failure, NoteEntity>> uploadNote({
    required File? image,
    required String title,
    required String content,
  });
  Future<Either<Failure, List<NoteEntity>>> getAllNotes();
}
