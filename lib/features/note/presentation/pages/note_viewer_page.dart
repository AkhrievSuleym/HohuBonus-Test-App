import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/theme/app_pallete.dart';
import 'package:hb_test_app/core/utils/format_date.dart';
import 'package:hb_test_app/features/note/presentation/pages/note_page.dart';
import 'package:flutter/material.dart';

class NoteViewerPage extends StatefulWidget {
  static route(NoteEntity note) => MaterialPageRoute(
        builder: (context) => NoteViewerPage(note: note),
      );

  final NoteEntity note;

  const NoteViewerPage({
    super.key,
    required this.note,
  });

  @override
  State<NoteViewerPage> createState() => _NoteViewerPageState();
}

class _NoteViewerPageState extends State<NoteViewerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  NotePage.route(),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.arrow_back_ios_new_sharp))),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Note title: ${widget.note.title}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  formatDateBydMMMYYYY(widget.note.updatedAt),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppPallete.greyColor,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      widget.note.imageUrl,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  widget.note.content,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
