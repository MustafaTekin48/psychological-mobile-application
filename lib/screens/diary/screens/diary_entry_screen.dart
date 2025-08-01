import 'package:flutter/material.dart';

class DiaryEntryPage extends StatefulWidget {
  final String emotion;

  DiaryEntryPage({required this.emotion});

  @override
  _DiaryEntryPageState createState() => _DiaryEntryPageState();
}

class _DiaryEntryPageState extends State<DiaryEntryPage> {
  final TextEditingController _reasonController = TextEditingController();
  int _selectedRating = 6; // Varsayılan olarak 6 seçili

  // Notu kaydetme fonksiyonu
  void _saveNote() {
    String reason = _reasonController.text;
    int rating = _selectedRating;

    if (reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen duygunuzun nedenini açıklayın.'),
        ),
      );
      return;
    }

    Map<String, dynamic> newEntry = {
      'emotion': widget.emotion,
      'reason': reason,
      'rating': rating,
      'date': DateTime.now(), // Günlük giriş tarihi burada ekleniyor
    };

    Navigator.pop(context, newEntry); // Yeni günlük verisini geri gönder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      appBar: AppBar(
        title: Text('Neden ${widget.emotion} hissediyorsunuz?'),
        backgroundColor: _getEmotionColor(widget.emotion), // AppBar rengi
      ),
      body: SingleChildScrollView( // Burada SingleChildScrollView ekliyoruz
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: _getEmotionColor(widget.emotion)?.withOpacity(0.3), // Arka plan rengi
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Neden ${widget.emotion} hissediyorsunuz?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                ' ${widget.emotion} olma durumunuzu oylayınız:',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [2, 4, 6, 8, 10].map((rating) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = rating;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: BoxDecoration(
                        color: _selectedRating == rating
                            ? Colors.red.shade300 // Seçili rating rengi kırmızı
                            : Colors.grey.shade300, // Seçilmemiş rating rengi gri
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        rating.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: _selectedRating == rating
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Cancel butonu için gri renk
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('İptal'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade300, // Add butonu için kırmızı renk
                    ),
                    onPressed: _saveNote, // Notu kaydet fonksiyonu
                    child: Text('Ekle'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Duyguya göre arka plan rengi belirleme
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) { // Emotion'u küçük harfe çeviriyoruz
      case 'mutlu':
        return Color(0xFFFFF3B0);
      case 'heyecanlı':
        return Color(0xFFFFD1A4);
      case 'normal':
        return Color(0xFFB2E0A8);
      case 'üzgün':
        return Color(0xFFAEC6FF);
      case 'kızgın':
        return Color(0xFFFFB3B3);
      case 'korkulu':
        return Color(0xFFD1B3FF);
      default:
        return Colors.black;
    }
  }
}
