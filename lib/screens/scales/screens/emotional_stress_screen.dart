
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/scales/NotificationHelper.dart';

import '../scales_class.dart';

//Algılanan Stres ölçeği sınıfı oluşturma

class EmotionalStressInv extends StatefulWidget {
  const EmotionalStressInv({super.key});

  @override
  State<EmotionalStressInv> createState() => _EmotionalStressInvState();
}

class _EmotionalStressInvState extends State<EmotionalStressInv> {
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

    // Değişkenlerin tanımlanması
    title = "Algılanan Stres Ölçeği"; //başlık
    instruction = "Aşağıda verilen Algılanan Stres Ölçeği  soruları, son bir ay içindeki"
        "duygu ve düşünceleriniz hakkında sorular yöneltir. Her durumda, belirli bir şekilde ne sıklıkla"
        "hissettiğinizi veya düşündüğünüzü belirtmeniz istenecektir. Sorulardan bazıları benzer olsa da,"
        "aralarında farklar bulunmaktadır ve her birini ayrı bir soru olarak ele almanız gerekmektedir. En iyi"
        "yaklaşım, soruları çok fazla düşünmeden hızlıca cevaplamaktır."; //açıklama
    questions = [
      "Son bir ayda, beklenmedik bir şey olduğu için ne sıklıkla üzüldünüz?",
      "Son bir ayda, hayatınızdaki önemli şeyleri kontrol edemediğinizi ne sıklıkla hissettiniz?",
      "Son bir ayda, ne sıklıkla sinirli ve stresli hissettiniz?",
      "Son bir ayda, kişisel sorunlarınızı çözme yeteneğinize ne sıklıkla güvendiniz?",
      "Son bir ayda, işlerinizin yolunda gittiğini ne sıklıkla hissettiniz?",
      "Son bir ayda, yapmanız gereken tüm işleri başaramayacağınızı ne sıklıkla hissettiniz?",
      "Son bir ayda, hayatınızdaki can sıkıcı şeyleri kontrol edebildiğinizi ne sıklıkla hissettiniz?",
      "Son bir ayda, her şeyin kontrolünüz altında olduğunu ne sıklıkla hissettiniz?",
      "Son bir ayda, kontrolünüz dışındaki olaylar yüzünden ne sıklıkla öfkelendiniz?",
      "Son bir ayda, zorlukların o kadar üst üste biriktiğini ve üstesinden gelemeyeceğinizi ne sıklıkla hissettiniz?"
    ]; //sorular

    options = [0, 1, 2, 3, 4]; //seçenekler

    // Başlangıçta kullanıcının seçtiği cevapları varsayılan olarak 0 olarak ata
    selectedAnswers = List<int>.filled(questions.length, 0);

    reversedAnswers = [false, false, false, true, true, false, true, true, false, false]; // Ters maddeler

    // Survey nesnesi
    survey = Survey(title, instruction, questions, options, [], selectedAnswers, reversedAnswers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(survey.title),
        backgroundColor: Colors.teal, // AppBar rengi
      ),
      body: ListView.builder(
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
                        switch (option) { //seçenekler
                          case 0:
                            optionText = "Hiçbir Zaman";
                            break;
                          case 1:
                            optionText = "Neredeyse Hiç";
                            break;
                          case 2:
                            optionText = "Bazen";
                            break;
                          case 3:
                            optionText = "Oldukça Sık";
                            break;
                          case 4:
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
                onPressed: () {
                  int totalScore = survey.sumResults(4, false); // Maksimum puanı 4 olarak hesapla
                  List score_range = survey.compareConditions(totalScore, ["Düşük Seviye Stres", "Orta Seviye Stres", "Yüksek Seviye Stres"], [0, 13, 14, 26, 27, 40]);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(child: Text('Sonucunuz')),
                        content: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '\nToplam Puanınız\n',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: '$totalScore\n \n',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: 'Dahil olduğunuz Kategori:\n',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: '\n${score_range[0]} ',
                                style: TextStyle(
                                  fontSize: 16.0,
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
                          textAlign: TextAlign.center,
                        ),
                        actions: <Widget>[
                      TextButton(
                      style: TextButton.styleFrom(
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal, // Buton rengi
                ),
                child: Text("Sonuçları Göster"),
              ),
            );
          }
        },
      ),
    );
  }
}





