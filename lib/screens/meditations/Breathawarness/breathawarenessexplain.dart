import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/Breathawarness/BreathAwareness.dart';

class breathawrenessexplain extends StatefulWidget {
  const breathawrenessexplain({super.key});

  static const String explain = "Nefes farkındalığı meditasyonu, zihnini doğal nefesine "
      "yönelterek ana odaklanmanı sağlar. Dikkatini her nefeste yeniden toplayarak, stresin azalmasına, zihinsel berraklığın artmasına ve "
      "içsel sakinliğin güçlenmesine yardımcı olur.";

  @override
  State<breathawrenessexplain> createState() => _breathawrenessexplainState();
}

class _breathawrenessexplainState extends State<breathawrenessexplain> {
  String? _selectedItem;
  String? _selectedthemeItem;

  final List<String> _items = [
    '3 Dakika',
    '5 Dakika',
    '10 Dakika',
  ];

  final List<String> _themeitems = [
    'yağmur',
    'deniz',
    'orman',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Nefes Farkındalığı Meditasyonu', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                breathawrenessexplain.explain,
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
                  "1. Sessiz bir ortamda rahat bir oturuş pozisyonu al. Gözlerini kapatabilirsin.\n"
                      "2. Nefes alışverişini değiştirmeden yalnızca gözlemle: Havanın burnundan girişini, göğsünün veya karnının hareketini fark et.\n"
                      "3. Zihnin dağıldığında bunu fark et ve yargılamadan nefesine geri dön.\n"
                      "4. Her nefesin farkında olarak kal: Şimdi nefes alıyorum - Şimdi nefes veriyorum gibi içsel cümleler kullanabilirsin.\n"
                      "5. Nefesin sana rehberlik etmesine izin ver. Zorlamadan, sadece fark ederek kal.\n"
                      "6. Meditasyonun sonunda birkaç derin nefes al ve çevrenin farkına var.",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 30),
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
                  if (_selectedItem == null) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Uyarı"),
                        content: const Text("Lütfen bir meditasyon süresi seçin"),
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
                    case '3 Dakika':
                      totalSeconds = 180;
                      break;
                    case '5 Dakika':
                      totalSeconds = 300;
                      break;
                    case '10 Dakika':
                      totalSeconds = 600;
                      break;
                  }

                  String themeName = 'background1.mp4';
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
                      builder: (context) => BreathAwareness(
                        totalSeconds: totalSeconds,
                        themeName: themeName,
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
