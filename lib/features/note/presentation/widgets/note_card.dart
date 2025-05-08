import 'package:hb_test_app/core/common/entities/note_entity.dart';
import 'package:hb_test_app/core/theme/app_pallete.dart';
import 'package:hb_test_app/features/note/presentation/pages/note_viewer_page.dart';
import 'package:flutter/material.dart';

class NoteCard extends StatelessWidget {
  final NoteEntity note;
  const NoteCard({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, NoteViewerPage.route(note));
      },
      child: Container(
        height: 540,
        padding: const EdgeInsets.only(bottom: 5),
        margin: const EdgeInsets.all(16).copyWith(bottom: 4),
        decoration: BoxDecoration(
          color: AppPallete.backgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'BigShouldersStencil',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: note.imageUrl != ''
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(0),
                          child: Image.network(
                            note.imageUrl,
                            fit: BoxFit.cover,
                            height: 350,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(Icons.image, size: 50),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
