import 'package:flutter/material.dart';

class EditEntryPage extends StatefulWidget {
  final Map<String, dynamic> entry; // Düzenlenecek giriş verisi

  EditEntryPage({required this.entry});

  @override
  _EditEntryPageState createState() => _EditEntryPageState();
}

class _EditEntryPageState extends State<EditEntryPage> {
  late TextEditingController _reasonController;
  late int _selectedRating;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(text: widget.entry['reason']); // Mevcut sebebi doldur
    _selectedRating = widget.entry['rating']; // Mevcut ratingi doldur
  }

  // Duyguya göre arka plan rengini belirleme
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
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

  // Düzenlemeleri kaydetme fonksiyonu
  void _saveEditedNote() {
    String updatedReason = _reasonController.text;
    int updatedRating = _selectedRating;

    Map<String, dynamic> updatedEntry = {
      'emotion': widget.entry['emotion'],
      'reason': updatedReason,
      'rating': updatedRating,
    };

    Navigator.pop(context, updatedEntry); // Düzenlenen notu geri gönder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Düzenleyiniz'),
        backgroundColor: _getEmotionColor(widget.entry['emotion']), // Duyguya göre AppBar rengi
      ),
      body: SingleChildScrollView( // İçeriğin taşmasını önlemek için kaydırılabilir hale getiriyoruz
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: _getEmotionColor(widget.entry['emotion'])?.withOpacity(0.3), // Duyguya göre arka plan rengi
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Neden ${widget.entry['emotion']} hissettiğinizi düzenleyin?',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                ' ${widget.entry['emotion']} olma durumunuzu oylayınız:',
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
                            ? Colors.red
                            : Colors.grey.shade300,
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
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.pop(context); // İptal et ve geri dön
                    },
                    child: Text('İptal'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: _saveEditedNote, // Düzenlemeleri kaydet
                    child: Text('Kaydet'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
