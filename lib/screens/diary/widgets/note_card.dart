import 'package:flutter/material.dart';

import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;

  NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(note.emotion),
        subtitle: Text(note.description),
        trailing: Text('${note.rating}/10'),
      ),
    );
  }
}
