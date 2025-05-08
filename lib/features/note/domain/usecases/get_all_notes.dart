import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/error/failures.dart';
import 'package:hb_test_app/core/usecases/usecase.dart';
import 'package:hb_test_app/features/note/domain/repositories/note_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllNotes implements UseCase<List<NoteEntity>, EmptyParams> {
  final NoteRepository noteRepository;

  GetAllNotes(this.noteRepository);

  @override
  Future<Either<Failure, List<NoteEntity>>> call(EmptyParams params) async {
    return await noteRepository.getAllNotes();
  }
}
