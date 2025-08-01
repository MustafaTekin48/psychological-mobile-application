import 'package:flutter/material.dart';
import 'ScaleDatabaseHelper.dart';

class ScaleResults extends StatefulWidget {
  const ScaleResults({Key? key}) : super(key: key);

  @override
  _ScaleResultsState createState() => _ScaleResultsState();
}

class _ScaleResultsState extends State<ScaleResults> {
  final ScaleDatabaseHelper dbHelper = ScaleDatabaseHelper();

  final Map<String, String> scaleMap = {
    'beck_anxiety': 'Beck Anksiyete Ölçeği',
    'beck_hopelessness': 'Beck Umutsuzluk Ölçeği',
    'big_five': 'Büyük Beşli Kişilik Testi',
    'depressionTable': 'Depresyon Ölçeği',
    'edinburgh_wellbeing': 'Edinburgh Refah Ölçeği',
    'perceived_stress': 'Algılanan Stres Ölçeği'
  };

  String? selectedScaleKey;
  List<Map<String, dynamic>> scaleResults = [];

  @override
  void initState() {
    super.initState();
    selectedScaleKey = scaleMap.keys.first;
    getScaleResultsFor(selectedScaleKey!);
  }

  Future<void> getScaleResultsFor(String scaleKey) async {
    try {
      final results = await dbHelper.getScaleResults(scaleKey);
      print("Çekilen veriler: $results");
      setState(() {
        scaleResults = results;
      });
    } catch (e) {
      print("Veri çekme hatası: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ölçek Sonuçları"),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.lightGreen[100],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedScaleKey,
              onChanged: (String? newKey) {
                if (newKey != null) {
                  setState(() {
                    selectedScaleKey = newKey;
                  });
                  getScaleResultsFor(newKey);
                }
              },
              items: scaleMap.entries.map<DropdownMenuItem<String>>((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: scaleResults.isEmpty
                  ? const Center(child: Text("Henüz sonuç yok."))
                  : ListView.builder(
                itemCount: scaleResults.length,
                itemBuilder: (context, index) {
                  final result = scaleResults[index];
                  return Card(
                    child: ListTile(
                      title: Text("${result['created_at'] ?? 'Bilinmiyor'} Tarihli Ölçek "),
                      //subtitle: Text("Tarih: ${result['created_at'] ?? 'Bilinmiyor'}"),
                      onTap: () => _showResultDetails(context, result),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDetails(BuildContext context, Map<String, dynamic> result) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Detaylar"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: result.entries.map((entry) {
                return ListTile(
                  title: Text("${entry.key}"),
                  subtitle: Text("${entry.value}"),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Kapat"),
            ),
          ],
        );
      },
    );
  }}