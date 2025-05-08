import 'package:hb_test_app/core/theme/app_theme.dart';
import 'package:hb_test_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:hb_test_app/features/note/presentation/pages/note_page.dart';
import 'package:hb_test_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<NoteBloc>(),
      ),
    ],
    child: const NoteApp(),
  ));
}

class NoteApp extends StatefulWidget {
  const NoteApp({super.key});

  @override
  State<NoteApp> createState() => _NoteAppState();
}

class _NoteAppState extends State<NoteApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const NotePage();
  }
}
