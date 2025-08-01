import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/MeditationJournals/meditation_callendar.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import '../MeditationJournals/meditation_journal.dart';

class BreathAwareness extends StatefulWidget {
  final int totalSeconds;
  final String themeName;

  const BreathAwareness({
    super.key,
    required this.totalSeconds,
    required this.themeName,
  });

  @override
  State<BreathAwareness> createState() => _BreathAwarenessState();
}

class _BreathAwarenessState extends State<BreathAwareness> {
  late int _totalSeconds;
  late int _remainingSeconds;
  late String _themeName;
  late VideoPlayerController _videoController;
  Timer? _timer;
  bool _isRunning = false;

  String _currentMotivationMessage = '';
  Timer? _motivationTimer;
  int _currentMotivationMessageIndex = 0;

  final List<String> _motivationMessages = [
    'Zihnin dağıldığında nazikçe nefesine dön.',
    'Her nefes yeni bir başlangıçtır.',
    'Şimdi nefes alıyorum, şimdi nefes veriyorum.',
    'Vücudundaki hisleri fark et.',
    'Düşünceler gelir ve geçer, sen sadece izle.'
  ];

  final List<String> startmessageList = [
    'Hazırsan, gözlerini kapat ve nefesine odaklan.',
    'Bu an sadece senin. Huzuru bulmaya niyet et',
    'Her nefesle içindeki sakinliği keşfet.'
  ];

  final List<String> endmessageList = [
    'Harika bir iş çıkardın!',
    'Bu sakinliği gününe taşı.',
    'Kendine ayırdığın bu zaman için teşekkür et.'
  ];

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.totalSeconds;
    _remainingSeconds = _totalSeconds;
    _themeName = widget.themeName;

    _videoController = VideoPlayerController.asset('assets/media/$_themeName')
      ..setLooping(true)
      ..setVolume(1.0)
      ..initialize().then((_) {
        setState(() {});
        _videoController.play();
        _showInitialMotivationMessage();
      });
  }

  void _showInitialMotivationMessage() {
    setState(() {
      _currentMotivationMessage = startmessageList[0];
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentMotivationMessage = '';
        });
        _startMotivationMessages();
      }
    });
  }

  void _startMotivationMessages() {
    _motivationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
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
    _motivationTimer?.cancel();
    _videoController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _videoController.play();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _videoController.pause();
          _showCompletionDialog();
          _showEndMotivationMessage();
        }
      });
    });
  }

  void _showEndMotivationMessage() {
    setState(() {
      _currentMotivationMessage = endmessageList[0];
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _currentMotivationMessage = '';
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _videoController.pause();
      _currentMotivationMessage = '';
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = _totalSeconds;
      _isRunning = false;
      _videoController.pause();
      _currentMotivationMessage = '';
    });
  }

  String _formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

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
              meditationThemeName: "Nefes Farkındalığı Meditasyonu",
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
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emin misiniz?'),
        content: const Text('Meditasyonu sonlandırmak istediğinizden emin misiniz?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Hayır'),
          ),
          TextButton(
            onPressed: () {
              _stopTimer();
              Navigator.of(context).pop(true);
            },
            child: const Text('Evet'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    double progress = _remainingSeconds / _totalSeconds;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Nefes Farkındalığı Meditasyonu',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_videoController.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
                ),
              ),
            Container(
              color: Colors.black.withOpacity(0.3),
            ),
            Positioned(
              bottom: 120,
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
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(color: Colors.white, fontSize: 32),
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
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}