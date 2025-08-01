import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../scales_class.dart';

class BigFiveInv extends StatefulWidget {
  const BigFiveInv({super.key});

  @override
  State<BigFiveInv> createState() => _BigFiveInvState();
}

class _BigFiveInvState extends State<BigFiveInv> {
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
  late SurveyBigFive survey;

  @override
  void initState() {
    super.initState();

    // Değişkenlerin başlatılması
    title = "Büyük 5 Kişilik Özelliği Ölçeği";
    instruction = "Aşağıdaki Büyük Kişilik Ölçeği, "
        "davranışlarınızı anlamanıza ve kişiliğinizin nasıl yapılandığını"
        " anlamanıza yardımcı olacaktır. Her bir ifadeyle ne kadar "
        "katılmadığınızı veya katıldığınızı belirten seçeneği işaretleyiniz. "
        "Her ifadeye Ben... ile başlayın.";
    questions = [
      "Partinin neşesi olan kişiyim.",
      "Diğerleri için çok az endişe duyarım.",
      "Her zaman hazırlıklıyım.",
      "Kolayca strese girerim.",
      "Zengin bir kelime dağarcığım var.",
      "Çok konuşmam.",
      "İnsanlara ilgi duyarım.",
      "Eşyalarımı etrafa bırakırım.",
      "Çoğu zaman rahatım.",
      "Soyut fikirleri anlamakta zorlanırım.",
      "İnsanların yanında kendimi rahat hissederim.",
      "İnsanlara hakaret ederim.",
      "Detaylara dikkat ederim.",
      "Şeyler hakkında endişelenirim.",
      "Canlı bir hayal gücüm var.",
      "Arka planda kalmayı tercih ederim.",
      "Başkalarının duygularına empati yaparım.",
      "İşleri karıştırırım.",
      "Nadiren üzgün hissederim.",
      "Soyut fikirlerle ilgilenmiyorum.",
      "Konuşma başlatırım.",
      "Başkalarının sorunlarıyla ilgilenmiyorum.",
      "Yapmam gereken işleri hemen hallederim.",
      "Kolayca rahatsız olurum.",
      "Harika fikirlerim var.",
      "Çok fazla söyleyecek bir şeyim yok.",
      "Yumuşak bir kalbim var.",
      "Eşyaları yerlerine koymayı sıklıkla unuturum.",
      "Kolayca üzülürüm.",
      "İyi bir hayal gücüm yok.",
      "Partilerde birçok farklı insanla konuşurum.",
      "Diğerlerine gerçekten ilgi duymuyorum.",
      "Düzeni severim.",
      "Duygu durumum sık sık değişir.",
      "Durumları hızlıca anlarım.",
      "Dikkat çekmeyi sevmem.",
      "Başkaları için zaman ayırırım.",
      "Görevlerimi aksatırım.",
      "Sık sık ruh halim değişir.",
      "Nadir kelimeler kullanırım.",
      "Dikkatin merkezinde olmaktan rahatsız olmam.",
      "Başkalarının duygularını hissederim.",
      "Bir programa uyarım.",
      "Kolayca sinirlenirim.",
      "Bazı şeyler üzerinde düşünmek için zaman harcarım.",
      "Yabancılar arasında sessizimdir.",
      "İnsanların rahat hissetmesini sağlarım.",
      "İşimde titizimdir.",
      "Sık sık üzgün hissederim.",
      "Fikir doluyum."
    ];

    options = [0, 1, 2, 3, 4];

    // Başlangıçta kullanıcının seçtiği cevapları varsayılan olarak 0 yapalım.
    selectedAnswers = List<int>.filled(questions.length, 0);

    reversedAnswers = List<bool>.filled(questions.length, false);
    // Örneğin, bazı soruları ters puanlı olarak ayarlayabilirsiniz:
    // reversedAnswers[3] = true;
    // reversedAnswers[4] = true;
    // ... devam edin.

    // Survey nesnesi
    // Survey nesnesi
    survey = SurveyBigFive(
      title,
      instruction,
      questions,
      options,
      [], // trueAnswers boş bırakılmış
      selectedAnswers,
      reversedAnswers,
      0,
      0,
      0,
      0,
      0,
    );
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
        itemCount: 1 + survey.questions.length + 1,
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
                            optionText = "Kesinlikle Katılmıyorum";
                            break;
                          case 1:
                            optionText = "Hafif Düzeyde Katılmıyorum";
                            break;
                          case 2:
                            optionText = "Nötrüm";
                            break;
                          case 3:
                            optionText = "Hafif Düzeyde Katılıyorum";
                            break;
                          case 4:
                            optionText = "Kesinlikle Katılıyorum";
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
                  List<int> totalScores = survey.sumResults1(4, false);

                  List<BarChartGroupData> barGroups = [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalScores[0].toDouble(),
                          color: Colors.blue,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: totalScores[1].toDouble(),
                          color: Colors.green,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: totalScores[2].toDouble(),
                          color: Colors.orange,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 3,
                      barRods: [
                        BarChartRodData(
                          toY: totalScores[3].toDouble(),
                          color: Colors.red,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [
                        BarChartRodData(
                          toY: totalScores[4].toDouble(),
                          color: Colors.purple,
                          width: 10,
                          borderRadius: BorderRadius.circular(4),
                        )
                      ],
                    ),
                  ];

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title:  Center(child: Text('Sonucunuz')),
                        content: Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 50,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    return null;
                                  },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      String label;
                                      switch (value.toInt()) {
                                        case 0:
                                          label = 'Dışa\nDönüklük';
                                          break;
                                        case 1:
                                          label = 'Uyumluluk';
                                          break;
                                        case 2:
                                          label = 'Sorumluluk';
                                          break;
                                        case 3:
                                          label = 'Nevrotiklik';
                                          break;
                                        case 4:
                                          label = 'Deneyime\nAçıklık';
                                          break;
                                        default:
                                          label = '';
                                      }
                                      return  SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 6,
                                          ),
                                          maxLines: 3, 
                                          overflow: TextOverflow.ellipsis, // Taşma durumunda noktalarla gösterir
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 10,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              barGroups: barGroups,
                            ),
                          ),
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

