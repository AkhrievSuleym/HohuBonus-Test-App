import 'package:hb_test_app/features/note/data/models/note_model.dart';
import 'package:hive/hive.dart';

abstract interface class NoteLocalDataSource {
  void uploadLocalNotes({required List<NoteModel> notes});
  List<NoteModel> loadNotes();
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Box box;
  NoteLocalDataSourceImpl(this.box);

  @override
  List<NoteModel> loadNotes() {
    List<NoteModel> notes = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        notes.add(NoteModel.fromJson(box.get(i.toString())));
      }
    });

    return notes;
  }

  @override
  void uploadLocalNotes({required List<NoteModel> notes}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < notes.length; i++) {
        box.put(i.toString(), notes[i].toJson());
      }
    });
  }
}
