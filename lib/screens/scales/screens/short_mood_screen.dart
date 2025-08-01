import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/scales/NotificationHelper.dart';

import '../scales_class.dart';


class ShortMoodInv extends StatefulWidget {
  const ShortMoodInv({super.key});

  @override
  State<ShortMoodInv> createState() => _ShortMoodInvState();
}

class _ShortMoodInvState extends State<ShortMoodInv> {
  Random random = Random();

  // Değişkenler
  late String title;
  late String instruction;
  late List<String> questions;
  late List<int> options;
  late List<int> trueAnswers;
  late List<int> selectedAnswers;
  late List<bool> reversedAnswers;

  // Survey nesnesi
  late Survey survey;

  @override
  void initState() {
    super.initState();

    // Değişkenlerin başlatılması
    title = "Warwick-Edinburgh Mental İyi Oluş Ölçeği Kısa Formu";
    instruction = "Aşağıdaki Warwick-Edinburgh Mental İyi Oluş Ölçeği Kısa Formunda yer alan duygular ve düşüncelerle ilgili bazı ifadeler verilmiştir. Lütfen her bir ifadeyi son 2 hafta içindeki yaşantınıza göre işaretleyiniz.";
    questions = ["Gelecek konusunda iyimserim. ",
      "Kendimi işe yarar hissediyorum.",
      "Kendimi rahat hissediyorum.",
      "Sorunlarla iyi bir biçimde başa çıkıyorum.",
      "Sağlıklı düşünüyorum.",
      "Çevremdeki diğer insanlara kendimi yakın hissediyorum. ",
      "Kendi kararlarımı kendim verebiliyorum. "

    ];

    options = [1, 2, 3,4,5];

    // Başlangıçta kullanıcının seçtiği cevapları varsayılan olarak 1 seç.
    selectedAnswers = List<int>.filled(questions.length, 1);

    reversedAnswers = List<bool>.filled(questions.length, false); // Ters cevaplar

    // Survey nesnesi
    survey = Survey(title, instruction, questions, options, [], selectedAnswers, reversedAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(// listView ile soru metinleri ve seçeneklerin Survey nesnesindeki question ve options uzunluğuna göre tanımlama
        padding: const EdgeInsets.all(16.0),
        itemCount: 1 + survey.questions.length + 1, // 1 for instruction, questions.length for questions, 1 for button
        itemBuilder: (context, index) {
          if (index == 0) {
            // Instruction
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  survey.instruction,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else if (index <= survey.questions.length) {
            // Questions
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
                          case 1:
                            optionText = "Hiçbir Zaman";
                            break;
                          case 2:
                            optionText = "Nadiren";
                            break;
                          case 3:
                            optionText = "Bazen";
                            break;
                          case 4:
                            optionText = "Sık Sık";
                            break;
                          case 5:
                            optionText = "Her Zaman";
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
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else {
            // Sonuç butonu
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  int totalScore = survey.sumResults(3, false); // Maksimum puanı 3 olarak hesapla
                  List score_range=     survey.compareConditions(totalScore, [""], []);
                  showDialog(context: context, builder: (BuildContext context) {
                    return AlertDialog(
                      title:  Center(child: Text('Sonucunuz')),
                      content:  Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\nToplam Puanınız\n',
                              style: TextStyle(
                                fontSize: 18.0, // 
                                fontWeight: FontWeight.bold,
                                color: Colors.black,

                              ),
                            ),
                            TextSpan(
                              text: '$totalScore\n \n',
                              style: TextStyle(
                                fontSize: 18.0, // 
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '\n*Bu formda kesme puanları yerine 7-35 arasında puan arttıkça olumlu duygu ve düşünce artışını gösterir ',
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,

                              ),
                            ),
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
                        textAlign: TextAlign.center, // Metni ortalamak için

                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.teal,
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          child: Center(child: const Text('Tamam')),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.pop(context);


                            // Bildirim gönderme (3 ay sonra)
                            var currentTime = DateTime.now();
                            var scheduledTime = currentTime.add(Duration(days: 90)); // 3 ay sonra
                            NotificationHelper.scheduleNotification(
                              "Mental İyi Oluş Ölçeği",
                              "3 aylık tekrar test dönemi.",
                              scheduledTime,
                            );
                          },
                        ),

                      ],
                    );
                  },);
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




