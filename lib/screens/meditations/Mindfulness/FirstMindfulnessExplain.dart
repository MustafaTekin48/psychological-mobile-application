import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/Mindfulness/FirstMindfulness.dart';

class Firstmindfulnessexplain extends StatefulWidget {
  const Firstmindfulnessexplain({super.key});

  static const String explain = "Farkındalık temelli meditasyon, zihnini anda "
      "tutmayı ve düşünce ile duygularını yargılamadan gözlemlemeyi "
      "öğrenmeni sağlar. Bu meditasyon, stresle başa çıkmana, odaklanmanı "
      "artırmana ve duygusal farkındalığını güçlendirmene yardımcı olabilir.";

  static const String words = "1. Sessiz ve rahat bir ortamda otur ya da uzan. Gözlerini kapatabilirsin.\n"
      "2. Dikkatini burnundan girip çıkan doğal nefesine yönelt.\n"
      "3. Zihnin başka düşüncelere kayarsa, fark et ve yumuşakça nefesine geri dön.\n"
      "4. Duygular, sesler veya bedensel hisler fark edebilirsin — onları bastırmadan yalnızca gözlemle.\n"
      "5. Hiçbir şeyi değiştirmeye çalışma; sadece olanı olduğu gibi kabul et.\n"
      "6. Meditasyon boyunca her anı fark ederek geçirmeye çalış.";

  @override
  State<Firstmindfulnessexplain> createState() => _FirstmindfulnessexplainState();
}

class _FirstmindfulnessexplainState extends State<Firstmindfulnessexplain> {
  String? _selectedItem;
  String? _selectedthemeItem; // Tema seçimi için yeni değişken

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
        title: const Text('Farkındalık Meditasyonu', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                Firstmindfulnessexplain.explain,
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
              Text(
                Firstmindfulnessexplain.words,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              // Tema Seçimi DropdownButton eklendi
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
                  if (_selectedItem == null || _selectedthemeItem == null) { // Tema seçimi kontrolü eklendi
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Uyarı"),
                        content: const Text("Lütfen bir meditasyon süresi ve tema seçin"), // Uyarı mesajı güncellendi
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

                  // Tema adı seçimine göre ayarlandı
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
                      builder: (context) => FirstMindfulness(
                        totalSeconds: totalSeconds,
                        themeName: themeName, // Tema adı FirstMindfulness'e gönderildi
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
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