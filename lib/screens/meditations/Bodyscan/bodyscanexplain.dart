import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/Bodyscan/BodyScan.dart'; // BodyScan import'unun doğru olduğundan emin olun

class bodyscanexplain extends StatefulWidget {
  const bodyscanexplain({super.key});

  static const String explain = "Beden tarama meditasyonu, bedeninin farklı"
      " bölgelerine dikkatini sırayla yönlendirerek farkındalığını"
      " artırmanı sağlar. Bu uygulama, zihinsel sakinlik, stres azaltımı"
      " ve bedensel farkındalık geliştirme için güçlü bir tekniktir.";

  @override
  State<bodyscanexplain> createState() => _bodyscanexplainState();
}

class _bodyscanexplainState extends State<bodyscanexplain> {
  String? _selectedItem;
  String? _selectedthemeItem; // Tema seçimi için değişken

  final List<String> _items = [
    '5 Dakika',
    '10 Dakika',
    '15 Dakika',
  ];

  final List<String> _themeitems = [ // Tema seçenekleri listesi
    'yağmur',
    'deniz',
    'orman',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Beden Tarama Meditasyonu', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                bodyscanexplain.explain,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                "Talimatlar:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "1. Ayak parmaklarınızdan başlayarak vücudunuzu yukarı doğru tarayın\n"
                      "2. Her bölgeye odaklanırken nefes alıp verin\n"
                      "3. Gerginlik hissettiğiniz bölgeleri fark edin\n"
                      "4. Her bölgede 3-5 nefes kalın",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
              // Tema Seçimi DropdownButton
              DropdownButton<String>(
                hint: const Text('Temayı Seçin'),
                value: _selectedthemeItem,
                items: _themeitems.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedthemeItem = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              // Meditasyon Süresi Seçimi DropdownButton
              DropdownButton<String>(
                hint: const Text('Meditasyon Süresi Seçin'),
                value: _selectedItem,
                items: _items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedItem = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_selectedItem == null || _selectedthemeItem == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Uyarı"),
                        content: const Text("Lütfen bir meditasyon süresi ve tema seçin"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Tamam"),
                          ),
                        ],
                      ),
                    );
                    return;
                  }

                  int totalSeconds = 300;
                  switch (_selectedItem) {
                    case '5 Dakika':
                      totalSeconds = 300;
                      break;
                    case '10 Dakika':
                      totalSeconds = 600;
                      break;
                    case '15 Dakika':
                      totalSeconds = 900;
                      break;
                  }

                  String themeName = 'background1.mp4'; // Varsayılan tema
                  switch (_selectedthemeItem) {
                    case 'yağmur':
                      themeName = 'background1.mp4';
                      break;
                    case 'deniz':
                      themeName = 'background2.mp4';
                      break;
                    case 'orman':
                      themeName = 'background3.mp4';
                      break;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BodyScan(
                        totalSeconds: totalSeconds,
                        themeName: themeName, // Tema adı BodyScan widget'ına gönderiliyor
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom( // 'from' yerine 'styleFrom' kullanıldı
                  minimumSize: const Size(200, 50),
                ),
                child: const Text("Başla", style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}