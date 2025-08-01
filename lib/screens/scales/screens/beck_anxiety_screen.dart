import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/scales/NotificationHelper.dart';
import 'dart:math';
import '../scales_class.dart';

class BeckAnxietyInv extends StatefulWidget {
  const BeckAnxietyInv({super.key});

  @override
  State<BeckAnxietyInv> createState() => _BeckAnxietyInvState();
}

class _BeckAnxietyInvState extends State<BeckAnxietyInv> {
  Random random = Random();
  late String title;
  late String instruction;
  late List<String> questions;
  late List<int> options;
  late List<int> selectedAnswers;
  late List<bool> reversedAnswers;
  late Survey survey;

  @override
  void initState() {
    super.initState();
    title = "BECK ANKSİYETE ENVANTERİ";
    instruction =
    "Aşağıda, insanların kaygılı ya da endişeli oldukları zamanlarda yaşadıkları bazı belirtiler verilmiştir. "
        "Lütfen her maddeyi dikkatle okuyunuz ve son bir haftadır sizi ne kadar rahatsız ettiğini belirtiniz.";

    questions = [
      "Bedeninizin herhangi bir yerinde uyuşma veya karıncalanma",
      "Sıcak/ateş basmaları",
      "Bacaklarda halsizlik, titreme",
      "Gevşeyememe",
      "Çok kötü şeyler olacak korkusu",
      "Baş dönmesi veya sersemlik",
      "Kalp çarpıntısı",
      "Dengeyi kaybetme duygusu",
      "Dehşete kapılma",
      "Sinirlilik",
      "Boğuluyormuş gibi olma duygusu",
      "Ellerde titreme",
      "Titreklik",
      "Kontrolü kaybetme korkusu",
      "Nefes almada güçlük",
      "Ölüm korkusu",
      "Korkuya kapılma",
      "Midede hazımsızlık ya da rahatsızlık hissi",
      "Baygınlık",
      "Yüzün kızarması",
      "Terleme (sıcaklığa bağlı olmayan)"
    ];

    options = [0, 1, 2, 3];
    selectedAnswers = List<int>.filled(questions.length, 0);
    reversedAnswers = List<bool>.filled(questions.length, false);

    survey = Survey(
      title,
      instruction,
      questions,
      options,
      [],
      selectedAnswers,
      reversedAnswers,
    );

    // Bildirim sistemini başlat
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: survey.questions.length + 2, // 1 for instruction, questions.length for questions, 1 for button
          itemBuilder: (context, index) {
            if (index == 0) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    survey.instruction,
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else if (index <= survey.questions.length) {
              int questionIndex = index - 1;
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${questionIndex + 1}. ${survey.questions[questionIndex]}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Column(
                        children: survey.options.map((option) {
                          String optionText;
                          switch (option) {
                            case 0:
                              optionText = "Hiç";
                              break;
                            case 1:
                              optionText = "Hafif - Pek etkilemedi";
                              break;
                            case 2:
                              optionText = "Orta - Katlanabildim";
                              break;
                            case 3:
                              optionText = "Ciddi - Dayanmakta zorlandım";
                              break;
                            default:
                              optionText = "";
                          }
                          return RadioListTile<int>(
                            activeColor: Colors.teal,
                            title: Text(optionText),
                            value: option,
                            groupValue: survey.selectedAnswers[questionIndex],
                            onChanged: (int? value) {
                              setState(() {
                                survey.selectedAnswers[questionIndex] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _showResults,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Sonuçları Göster",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
  @override


  void _showResults() {
    int totalScore = survey.sumResults(3, false);
    List scoreRange = survey.compareConditions(
      totalScore,
      ["Minimal anksiyete", "Hafif anksiyete", "Orta anksiyete", "Şiddetli anksiyete"],
      [0, 7, 8, 15, 16, 25, 26, 63],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Sonucunuz',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Toplam Puanınız\n',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '$totalScore\n',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      TextSpan(
                        text: 'Kategori:\n',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '\n${scoreRange[0]}\n',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black87,
                        ),
                      ),
                      TextSpan(
                          text: '* 3 ay sonra ölçek tekrarlanacaktır',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:  FontWeight.bold,
                            color: Colors.black87,
                          )
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);

                    // Bildirim gönderme (3 ay sonra)
                    var currentTime = DateTime.now();
                    var scheduledTime = currentTime.add(Duration(days: 90)); // 3 ay sonra
                    NotificationHelper.scheduleNotification(
                      "Algılanan Stress Ölçeği Sonucu",
                      "3 aylık tekrar test dönemi.",
                      scheduledTime,
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Tamam",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );


  }
}