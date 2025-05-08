import 'package:hb_test_app/core/network/connection.dart';
import 'package:hb_test_app/core/secrets/app_secrets.dart';
import 'package:hb_test_app/features/note/data/datasources/note_local_data_source.dart';
import 'package:hb_test_app/features/note/data/datasources/note_remote_data_source.dart';
import 'package:hb_test_app/features/note/data/repositories/note_repository_impl.dart';
import 'package:hb_test_app/features/note/domain/repositories/note_repository.dart';
import 'package:hb_test_app/features/note/domain/usecases/get_all_notes.dart';
import 'package:hb_test_app/features/note/domain/usecases/upload_note.dart';
import 'package:hb_test_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initNote();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseUrl, anonKey: AppSecrets.supabaseKey);

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => Hive.box(name: 'notes'));
  serviceLocator.registerFactory(() => InternetConnection());

  serviceLocator.registerLazySingleton(() => Logger());

  serviceLocator.registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()));
}

void _initNote() {
  serviceLocator
    //DataSource
    ..registerFactory<NoteRemoteDataSource>(
      () => NoteRemoteDataSourceImpl(
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory<NoteLocalDataSource>(
      () => NoteLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<NoteRepository>(
      () => NoteRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )

    //Usecases
    ..registerFactory(
      () => UploadNote(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllNotes(
        serviceLocator(),
      ),
    );

  serviceLocator.registerLazySingleton(
    () => NoteBloc(
      uploadNote: serviceLocator(),
      getAllNotes: serviceLocator(),
    ),
  );
}
