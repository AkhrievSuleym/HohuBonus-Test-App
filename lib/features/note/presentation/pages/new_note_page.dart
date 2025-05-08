import 'dart:io';

import 'package:hb_test_app/core/common/widgets/loading.dart';
import 'package:hb_test_app/core/theme/app_pallete.dart';
import 'package:hb_test_app/core/utils/pick_image.dart';
import 'package:hb_test_app/core/utils/show_snackbar.dart';
import 'package:hb_test_app/features/note/presentation/bloc/note_bloc.dart';
import 'package:hb_test_app/features/note/presentation/pages/note_page.dart';
import 'package:hb_test_app/features/note/presentation/widgets/note_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewNotePage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const NewNotePage());

  const NewNotePage({super.key});

  @override
  State<NewNotePage> createState() => _NewNotePageState();
}

class _NewNotePageState extends State<NewNotePage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  final formKey = GlobalKey<FormState>();
  File? image;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void saveNote() {
    context.read<NoteBloc>().add(
          NoteUploadEvent(
            title: titleController.text.trim(),
            content: contentController.text.trim(),
            image: image,
          ),
        );
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "New Note",
          style: TextStyle(
            fontFamily: 'BigShouldersStencil',
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                saveNote();
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteFailure) {
            showSnackBar(context, state.error, isError: true);
          } else if (state is NoteUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              NotePage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Loading();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 250,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => selectImage(),
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: const SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open_outlined,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('Select your image',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    NoteEditor(
                      controller: titleController,
                      hintText: 'Note title',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    NoteEditor(
                      controller: contentController,
                      hintText: 'Note content',
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
