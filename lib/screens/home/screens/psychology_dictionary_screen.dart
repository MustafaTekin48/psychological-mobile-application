import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class PsychologyDictionaryScreen extends StatefulWidget {
  const PsychologyDictionaryScreen({Key? key}) : super(key: key);

  @override
  _PsychologyDictionaryScreenState createState() =>
      _PsychologyDictionaryScreenState();
}

class _PsychologyDictionaryScreenState
    extends State<PsychologyDictionaryScreen> {
  List<Map<String, String>> terms = [];
  String searchQuery = "";
  String selectedLetter = "";

  @override
  void initState() {
    super.initState();
    loadTerms();
  }

  void loadTerms() async {
    final String response = await rootBundle.loadString('assets/data/dict1.csv');
    final List<String> lines = response.split('\n');

    setState(() {
      terms = lines
          .map((line) {
        final firstCommaIndex = line.indexOf(',');
        if (firstCommaIndex != -1) {
          final word = line.substring(0, firstCommaIndex).trim();
          final definition = line.substring(firstCommaIndex + 1).trim();
          return {
            'word': word,
            'definition': definition,
          };
        }
        return null;
      })
          .where((term) => term != null)
          .cast<Map<String, String>>()
          .toList();
    });

    // Debug için ekleyin:
    print("Yüklenen Terimler:");
    print(terms);
  }


  void filterTerms(String letter) {
    setState(() {
      selectedLetter = letter;
      searchQuery = ""; // Arama kutusunu sıfırla
    });
  }

  void clearFilters() {
    setState(() {
      selectedLetter = "";
      searchQuery = ""; // Arama metnini sıfırla
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredTerms = terms
        .where((term) =>
    (searchQuery.isEmpty ||
        term['word']!.toLowerCase().contains(searchQuery.toLowerCase())) &&
        (selectedLetter.isEmpty || term['word']!.startsWith(selectedLetter)))
        .toList();

// Debug için:
    print("Filtrelenen Kelimeler:");
    print(filteredTerms);



    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Psikoloji Sözlüğü',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF003366),
              Color(0xFF5C6BC0),
            ],
          ),
        ),
        child: Row(
          children: [
            // Dikey alfabe filtresi
            Container(
              width: 70,
              child: ListView.builder(
                itemCount: 26,
                itemBuilder: (context, index) {
                  String letter = String.fromCharCode(65 + index);
                  return GestureDetector(
                    onTap: () {
                      filterTerms(letter);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedLetter == letter
                            ? Colors.teal.withOpacity(0.6)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: selectedLetter == letter
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Arama kutusu ve Temizle ikonu
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: TextField(
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Ara',
                                hintStyle: const TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                  selectedLetter = ""; // Harf filtreleme seçimini sıfırla
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            // Arama butonuna basıldığında yapılacak işlemler
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white),
                          onPressed: clearFilters,
                        ),
                      ],
                    ),
                  ),
                  // Sözlük içeriği
                  Expanded(
                    child: filteredTerms.isEmpty
                        ? Center(
                      child: Text(
                        'Kelime bulunamadı',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: filteredTerms.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: Card(
                            color: Colors.white.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(20.0),
                              title: Text(
                                filteredTerms[index]['word']!,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1D2671),
                                ),
                              ),
                              subtitle: Text(
                                filteredTerms[index]['definition']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
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
