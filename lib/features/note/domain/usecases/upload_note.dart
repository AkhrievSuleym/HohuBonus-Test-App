import 'dart:io';

import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/error/failures.dart';
import 'package:hb_test_app/core/usecases/usecase.dart';
import 'package:hb_test_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadNote implements UseCase<NoteEntity, UploadNoteParams> {
  final NoteRepository noteRepository;

  UploadNote(this.noteRepository);

  @override
  Future<Either<Failure, NoteEntity>> call(UploadNoteParams params) async {
    return await noteRepository.uploadNote(
      image: params.image,
      title: params.title,
      content: params.content,
    );
  }
}

class UploadNoteParams {
  final String title;
  final String content;
  final File? image;

  UploadNoteParams({
    required this.title,
    required this.content,
    required this.image,
  });
}
