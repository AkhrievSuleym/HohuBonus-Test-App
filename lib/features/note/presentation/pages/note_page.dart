import 'package:hb_test_app/core/common/widgets/loading.dart';
import 'package:hb_test_app/core/utils/show_snackbar.dart';
import 'package:hb_test_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:hb_test_app/features/note/presentation/pages/new_note_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hb_test_app/features/note/presentation/widgets/note_card.dart';

class NotePage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const NotePage(),
      );
  const NotePage({
    super.key,
  });

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  @override
  void initState() {
    super.initState();
    context.read<NoteBloc>().add(GetAllNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dog Journal",
          style: TextStyle(
            fontFamily: 'BigShouldersStencil',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, NewNotePage.route());
            },
            icon: const Icon(CupertinoIcons.add_circled),
            iconSize: 36,
          )
        ],
      ),
      body: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteFailure) {
            showSnackBar(context, state.error, isError: true);
          }
        },
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Loading();
          } else if (state is NoteDisplaySuccess) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return NoteCard(
                  note: note,
                );
              },
            );
          }
          return const SizedBox(
            height: 15,
          );
        },
      ),
    );
  }
}
