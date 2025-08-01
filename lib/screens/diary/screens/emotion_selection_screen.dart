import 'package:flutter/material.dart';
import 'diary_entry_screen.dart';

class EmotionSelectionScreen extends StatelessWidget {
  final Function(Map<String, dynamic>) onNewEntry;

  EmotionSelectionScreen({required this.onNewEntry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bugün Nasıl Hissediyorsunuz?'),
        automaticallyImplyLeading: false, // Geri butonunu kaldırıyoruz
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          children: [
            EmotionButton(emotion: 'Mutlu', color: Color(0xFFFFF3B0), onNewEntry: onNewEntry),
            EmotionButton(emotion: 'Heyecanlı', color: Color(0xFFFFD1A4), onNewEntry: onNewEntry),
            EmotionButton(emotion: 'Normal', color: Color(0xFFB2E0A8), onNewEntry: onNewEntry),
            EmotionButton(emotion: 'Üzgün', color: Color(0xFFAEC6FF), onNewEntry: onNewEntry),
            EmotionButton(emotion: 'Kızgın', color: Color(0xFFFFB3B3), onNewEntry: onNewEntry),
            EmotionButton(emotion: 'Korkulu', color: Color(0xFFD1B3FF), onNewEntry: onNewEntry),
          ],
        ),
      ),
    );
  }
}

class EmotionButton extends StatelessWidget {
  final String emotion;
  final Color color;
  final Function(Map<String, dynamic>) onNewEntry;

  EmotionButton({required this.emotion, required this.color, required this.onNewEntry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryEntryPage(emotion: emotion),
          ),
        );
        if (result != null) {
          onNewEntry(result); // Yeni entry dönerse onu geri gönderiyoruz
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.0), // Daha modern yuvarlatılmış köşeler
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Gölge efekti
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            emotion,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black.withOpacity(0.8), // Yazı daha belirgin
            ),
          ),
        ),
      ),
    );
  }
}
