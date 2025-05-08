import 'dart:io';

import 'package:hb_test_app/core/error/exceptions.dart';
import 'package:hb_test_app/features/note/data/models/note_model.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class NoteRemoteDataSource {
  Future<NoteModel> uploadNote(NoteModel note);
  Future<String> uploadNoteImage({
    required File image,
    required NoteModel note,
  });
  Future<List<NoteModel>> getAllNotes();
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final SupabaseClient supabaseClient;
  final Logger _logger;

  NoteRemoteDataSourceImpl(this.supabaseClient, this._logger);

  @override
  Future<NoteModel> uploadNote(NoteModel note) async {
    try {
      final noteData =
          await supabaseClient.from('notes').insert(note.toJson()).select();
      return NoteModel.fromJson(noteData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadNoteImage({
    required File image,
    required NoteModel note,
  }) async {
    try {
      await supabaseClient.storage.from('note_images').upload(note.id, image);

      return supabaseClient.storage.from('note_images').getPublicUrl(note.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final notes = await supabaseClient.from('notes');
      return notes
          .map(
            (note) => NoteModel.fromJson(note).copyWith(),
          )
          .toList();
    } catch (e) {
      _logger.i(e.toString());
      throw ServerException(e.toString());
    }
  }
}
