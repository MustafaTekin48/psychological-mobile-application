import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/scales/NotificationHelper.dart';

import '../scales_class.dart';

class BeckDepressionInv extends StatefulWidget {
  const BeckDepressionInv({super.key});

  @override
  State<BeckDepressionInv> createState() => _BeckDepressionInvState();
}

class _BeckDepressionInvState extends State<BeckDepressionInv> {
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
    title = "CES-D Depresyon Ölçeği";
    instruction = "Aşağıda, duygularınıza ya da davranışlarınıza yönelik bir liste bulunmaktadır. "
        "Lütfen son bir hafta içerisinde ne sıklıkla kendinizi bu şekilde hissettiğinizi düşününüz ve her bir soruda sizin için en uygun seçeneği işaretleyiniz";
    questions = [
      "İştahım yoktu.", "Uykuya dalmakta güçlük yaşadım.", "Üzgün hissettim.", "Kendimi kötü biri gibi hissettim.",
      "Düzenli olarak yaptığım etkinliklere karşı ilgimi kaybettim.", "Çok yavaş hareket ettiğimi hissettim.", "Ölmeyi istedim.",
      "Kendimi hep yorgun hissettim.", "Önemli işlere odaklanamadım.", "Kendimi gergin hissettim."
    ];
    options = [0, 1, 2, 3];
    selectedAnswers = List<int>.filled(questions.length, 0);
    reversedAnswers = List<bool>.filled(questions.length, false);

    survey = Survey(title, instruction, questions, options, [], selectedAnswers, reversedAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: 1 + survey.questions.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  survey.instruction,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else if (index <= survey.questions.length) {
            int questionIndex = index - 1;
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${questionIndex + 1}. ${survey.questions[questionIndex]}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Column(
                      children: survey.options.map((option) {
                        String optionText;
                        switch (option) {
                          case 0:
                            optionText = "Son bir haftada hiç yaşamadım ya da 1 gün içerisinde çok az yaşadım.";
                            break;
                          case 1:
                            optionText = "Son bir haftada 1 ya da 2 gün yaşadım";
                            break;
                          case 2:
                            optionText = "Son bir haftada 3-4 gün yaşadım.";
                            break;
                          case 3:
                            optionText = "Son bir haftada 5-7 gün yaşadım.";
                            break;
                          default:
                            optionText = "";
                        }
                        return RadioListTile<int>(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  int totalScore = survey.sumResults(3, false);
                  List score_range = survey.compareConditions(
                      totalScore,
                      ["Minimal ya da hiç depresyon belirtisi", "Hafif depresyon belirtisi", "Orta düzeyde depresyon belirtisi", "Şiddetli depresyon belirtisi"],
                      [0, 10, 11, 15, 16, 20, 21, 30]);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text('Sonucunuz')),
                        content: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(text: '\nToplam Puanınız\n', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                              TextSpan(text: '$totalScore\n \n', style: TextStyle(fontSize: 18.0)),
                              TextSpan(text: 'Dahil olduğunuz Kategori:\n', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                              TextSpan(text: '\n${score_range[0]} ', style: TextStyle(fontSize: 16.0)),
                              TextSpan(
                                  text: '\n* 3 ay sonra ölçek tekrarlanacaktır',
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
                        actions: <Widget>[
                          TextButton(
                            child: Center(child: Text('Tamam')),
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
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Sonuçları Göster"),
              ),
            );
          }
        },
      ),
    );
  }
}
