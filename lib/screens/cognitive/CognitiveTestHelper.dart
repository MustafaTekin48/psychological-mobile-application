import 'dart:math';

class CognitiveTest {
  late List<int> options;
  late List<String> questionsList;
  late List<int> selectedAnswers;
  late List<String> tempList = [];


  CognitiveTest(this.options, this.questionsList, this.selectedAnswers, this.tempList);

  List<String> CrateTestQuestions() {
    // Soruları karıştır
    questionsList.shuffle(Random());

    // İlk 11 soruyu seç ve tempList'e ekle
    for (var i = 0; i < 11 && i < questionsList.length; i++) {
      tempList.add(questionsList[i]);
    }
    return tempList;
  }
}