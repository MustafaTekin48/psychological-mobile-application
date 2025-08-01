import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/scales/NotificationHelper.dart';

import '../scales_class.dart';

//Beck umutsuzluk ölçeği sınıfı oluşturma
class BeckHopelessnessInv extends StatefulWidget {
  const BeckHopelessnessInv({super.key});

  @override
  State<BeckHopelessnessInv> createState() => _BeckHopelessnessInvState();
}

class _BeckHopelessnessInvState extends State<BeckHopelessnessInv> {
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
    title = "Beck Umutsuzluk Ölçeği"; //başlık
    instruction = "Aşağıdaki ölçekte geleceğe yönelik olumsuz beklenti ya da düşünceleri içeren cümlelerden size "
        "uygun olanları evet ya da hayır olarak işaretleyiniz."; //açıklama

    questions = [
      "Geleceğe umut ve coşku ile bakıyorum",
      "Kendim ile ilgili şeyleri düzeltemediğime göre çabalamayı bıraksam iyi olur.",
      "İşler kötüye giderken bile her şeyin hep böyle kalmayacağını bilmek beni rahatlatıyor.",
      "Gelecek on yıl içinde hayatımın nasıl olacağını hayal bile edemiyorum.",
      "Yapmayı en çok istediğim şeyleri gerçekleştirmek için yeterli zamanım var.",
      "Benim için çok önemli konularda ileride başarılı olacağımı umuyorum.",
      "Geleceğimi karanlık görüyorum.",
      "Dünya nimetlerinden sıradan bir insandan daha çok yararlanacağımı umuyorum.",
      "İyi fırsatlar yakalayamıyorum.Gelecekte yakalayacağıma inanmam için de hiç bir neden yok",
      "Geçmiş deneyimlerim beni geleceğe iyi hazırladı.",
      "Gelecek benim için hoş şeylerden çok tatsızlıklarla dolu görünüyor.",
      "Gerçekten özlediğim şeylere kavuşabileceğimi ummuyorum",
      "Geleceğe baktığımda şimdikine oranla daha mutlu olacağımı umuyorum.",
      "İşler bir türlü benim istediğim gibi gitmiyor.",
      "Geleceğe büyük inancım var.",
      "Arzu ettiğim şeyleri elde edemediğime göre bir şeyler istemek aptallık olur.",
      "Gelecekte gerçek doyuma ulaşmam olanaksız gibi.",
      "Gelecek bana bulanık ve belirsiz görünüyor.",
      "Kötü günlerden çok, iyi günler bekliyorum.",
      "İstediğim her şeyi elde etmek için çaba göstermenin gerçekten yararı yok, nasıl olsa onu elde edemeyeceğim"
    ]; //sorular

    options = [0, 1]; //seçenekler

    // Başlangıçta kullanıcının seçtiği cevapları varsayılan olarak 0 olarak ayarla.
    selectedAnswers = List<int>.filled(questions.length, 0);

    reversedAnswers = [
      true, false, true, false, true, true, false, true, false,
      true, false, false, true, false, true,
      false, false, false, true, false
    ]; // Ters maddeler

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
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          case 0:
                            optionText = "Hayır";
                            break;
                          case 1:
                            optionText = "Evet";
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
                  int totalScore = survey.sumResults(1, false); // Maksimum puanı 1 olarak hesapla
                  List score_range = survey.compareConditions(
                      totalScore, ["Minimal ya da hiç umutsuzluk belirtisi", "Hafif umutsuzluk belirtisi", "Orta düzeyde umutsuzluk belirtisi", "Şiddetli umutsuzluk belirtisi"], [0, 3, 4, 8, 9, 14, 15, 20]);
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
                                "Beck Umutsuzluk Ölçeği Sonucu",
                                "3 ay önce tamamladığınız anksiyete testini hatırlatmak istedik.",
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