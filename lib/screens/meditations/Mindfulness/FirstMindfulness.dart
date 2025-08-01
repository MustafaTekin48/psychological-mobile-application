import 'package:flutter/material.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';

import '../MeditationJournals/meditation_journal.dart'; // Video oynatıcı için gerekli

class FirstMindfulness extends StatefulWidget {
  final int totalSeconds;
  final String themeName; // Tema adı için yeni parametre eklendi

  const FirstMindfulness({
    super.key,
    required this.totalSeconds,
    required this.themeName, // constructor'a eklendi
  });

  @override
  State<FirstMindfulness> createState() => _FirstMindfulnessState();
}

class _FirstMindfulnessState extends State<FirstMindfulness> {
  late int _totalSeconds;
  late int _remainingSeconds;
  late String _themeName; // Temayı tutacak değişken
  late VideoPlayerController _videoController; // Video oynatıcı kontrolcüsü
  Timer? _timer;
  bool _isRunning = false;

  String _currentMotivationMessage = ''; // Anlık motivasyon mesajı
  Timer? _motivationTimer;
  int _currentMotivationMessageIndex = 0; // Motivasyon mesaj listesi indeksi

  // Farkındalık Meditasyonu için özel motivasyon mesaj listeleri
  final List<String> _motivationMessages = [
    'Nefesine odaklan, o senin demir atın.',
    'Düşüncelerini bir bulut gibi izle, yargılamadan.',
    'Her nefesle ana dön.',
    'Bedenindeki hisleri nazikçe fark et.',
    'Dış seslere aldırmadan iç dünyana odaklan.',
    'Kendine şefkatle yaklaş.',
    'Bu anın tadını çıkar, o bir daha gelmeyecek.',
  ];

  final List<String> startmessageList = [
    'Farkındalık meditasyonuna hoş geldin.',
    'Şimdi ana odaklanma zamanı.',
    'Rahatla ve nefes alışverişine izin ver.',
  ];

  final List<String> endmessageList = [
    'Farkındalığını geliştirdiğin için tebrikler!',
    'Bu dinginliği gününe taşı.',
    'Anda kalma gücünü keşfettim.'
  ];

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.totalSeconds;
    _remainingSeconds = _totalSeconds;
    _themeName = widget.themeName; // Widget'tan gelen tema adını ata

    _videoController = VideoPlayerController.asset('assets/media/$_themeName')
      ..setLooping(true)
      ..setVolume(1.0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play(); // Video başlangıçta oynamaya başlar
        _showInitialMotivationMessage();  // Başlangıç mesajını göster
      });
  }

  // Başlangıç motivasyon mesajını gösterir ve sonra düzenli mesajları başlatır
  void _showInitialMotivationMessage() {
    setState(() {
      _currentMotivationMessage = startmessageList[0]; // İlk başlangıç mesajını göster
    });
    // Kısa bir süre sonra başlangıç mesajını gizle ve düzenli mesajları başlat
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) { // Widget hala ağaçta mı kontrol et
        setState(() {
          _currentMotivationMessage = ''; // Mesajı gizle
        });
        _startMotivationMessages(); // Düzenli motivasyon mesajlarını başlat
      }
    });
  }

  // Düzenli motivasyon mesajlarını belirli aralıklarla gösterir
  void _startMotivationMessages() {
    // Mesajları her 1 dakikada bir değiştirebiliriz, ihtiyaca göre bu aralığı ayarlayın.
    _motivationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) { // Widget hala ağaçta mı kontrol et
        setState(() {
          _currentMotivationMessage = _motivationMessages[_currentMotivationMessageIndex];
          _currentMotivationMessageIndex = (_currentMotivationMessageIndex + 1) % _motivationMessages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _motivationTimer?.cancel(); // Motivasyon timer'ını dispose et
    _videoController.dispose(); // Video kontrolcüsünü dispose et
    super.dispose();
  }

  // Meditasyon sayacını başlatır
  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _videoController.play(); // Meditasyon başlayınca video oynat
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _videoController.pause(); // Meditasyon bitince videoyu durdur
          _showCompletionDialog();
          _showEndMotivationMessage(); // Bitiş mesajını göster
        }
      });
    });
  }

  // Bitiş motivasyon mesajını gösterir
  void _showEndMotivationMessage() {
    setState(() {
      _currentMotivationMessage = endmessageList[0]; // İlk bitiş mesajını göster
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentMotivationMessage = ''; // Mesajı gizle
        });
      }
    });
  }

  // Meditasyon sayacını durdurur
  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _videoController.pause(); // Meditasyon durunca videoyu durdur
      _currentMotivationMessage = ''; // Durdurulduğunda mesajı gizle
    });
  }

  // Meditasyon sayacını sıfırlar
  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
      _videoController.pause(); // Sıfırlanınca videoyu durdur
      _currentMotivationMessage = ''; // Sıfırlandığında mesajı gizle
    });
  }

  // Saniyeleri dakika:saniye formatına dönüştürür
  String _formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Meditasyon tamamlandığında gösterilecek diyalog kutusu
  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Meditasyon Tamamlandı"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Nasıl hissediyorsunuz?"),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                _buildEmotionChip("Mutlu", Colors.green),
                _buildEmotionChip("Normal", Colors.blueGrey),
                _buildEmotionChip("Heyecanlı", Colors.orange),
                _buildEmotionChip("Üzgün", Colors.blue.shade300),
                _buildEmotionChip("Kızgın", Colors.red.shade400),
                _buildEmotionChip("Korkulu", Colors.purple.shade300),
                _buildEmotionChip("Yorgun", Colors.brown.shade300),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Kapat"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionChip(String emotion, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => meditation_journal(
              selectedEmotion: emotion,
              meditationCompletedToday: true,
              meditationThemeName: "Farkındalık Temelli Meditasyon", // Bu satırı ekleyin
            ),
          ),
        );
      },
      child: Chip(
        backgroundColor: color.withOpacity(0.2),
        label: Text(emotion),
        avatar: CircleAvatar(
          backgroundColor: color,
          child: Text(
            emotion[0].toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // Geri tuşuna basıldığında onay diyalog kutusunu gösterir
  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emin misiniz?'),
        content: const Text('Meditasyonu sonlandırmak istediğinizden emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Hayır, çıkma
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () {
              _stopTimer(); // Meditasyonu durdur
              Navigator.of(context).pop(true); // Evet, çık
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    )) ?? false; // Eğer diyalog kapatılırsa (null dönerse) false döndür
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingSeconds / _totalSeconds;

    return WillPopScope(
      onWillPop: _onWillPop, // Geri tuşu olayını yakala
      child: Scaffold(
        extendBodyBehindAppBar: true, // AppBar'ın arkasına içeriğin uzamasını sağlar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Şeffaf AppBar
          elevation: 0, // Gölge yok
          title: const Text(
            'Farkındalık Meditasyonu', // Başlık güncellendi
            style: TextStyle(color: Colors.white), // Metin rengi beyaz
          ),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand, // Stack'i tüm ekranı kaplayacak şekilde ayarla
          children: [
            // Video arka planı
            if (_videoController.value.isInitialized) // Video hazırsa göster
              FittedBox(
                fit: BoxFit.cover, // Videoyu ekranı kaplayacak şekilde sığdır
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            // Video üzerine hafif koyu bir katman (metin okunurluğu için)
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            // Motivasyon mesajı
            Positioned(
              bottom: 120, // Konumu ayarlayabilirsiniz
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: _currentMotivationMessage.isNotEmpty ? 1.0 : 0.0,
                duration: const Duration(seconds: 1),
                child: Text(
                  _currentMotivationMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue), // Mavi renk
                        ),
                      ),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(color: Colors.white, fontSize: 32), // Metin rengi beyaz
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.stop),
                        onPressed: _isRunning ? _stopTimer : null,
                        color: Colors.red,
                      ),
                      IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.play_arrow),
                        onPressed: _isRunning ? null : _startTimer,
                        color: Colors.green,
                      ),
                      IconButton(
                        iconSize: 50,
                        icon: const Icon(Icons.replay),
                        onPressed: _resetTimer,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}