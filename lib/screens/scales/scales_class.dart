class Survey {
  /* ölçek başlığı, açıklması, soru listesi, seçenek listesi, katılımcı
  cevapları ölçek cevapları ve ters madde bulunma durumu ile ilgili değişkenler
  ve Survey classının constructer ı tanımlandır.

   */
  String title;
  String instruction;
  List<String> questions;
  List<int> options;
  List<int> trueAnswers;
  List<int> selectedAnswers;
  List<bool> reversedAnswers;

  // Constructor
  Survey(this.title,
      this.instruction,
      this.questions,
      this.options,
      this.trueAnswers,
     this.selectedAnswers,
      this.reversedAnswers);

  //Ölçek oluşturma ve görüntüleme için createSurvey methodu
  void createSurvey() {
    print(title);
    print(instruction);
    for (var i = 0; i < questions.length; i++) {
      print('${i + 1}. ${questions[i]}');

      print('Seçenekler: $options\n');
      print("Cevap: ${selectedAnswers[i]}\n");
    }
  }
  //Ölçek sonuçlarını yorumlama için sumResults methodu
  int sumResults(int maxScore, bool printDetails) {
    int points = 0;
    //soru sayısı kadar seçilen cevabı gösteren for döngüsü
    for (var i = 0; i < questions.length; i++) {
      if (printDetails == true) {
        print('${i + 1}. ${questions[i]}');
        print('Seçilen Cevap: ${selectedAnswers[i]}');
      }
      //ters madde yoksa toplam puana seçenek puanını al
      if (reversedAnswers[i] == false) {
        points += selectedAnswers[i];  // Normal madde
      } else {
        // Ters madde varsa puanlamayı tersten yap
        int reversedScore = maxScore  - selectedAnswers[i];
        points += reversedScore;
        if (printDetails == true) {
          print('Ters Madde - Terslenen Puan: $reversedScore');
        }
      }
      //printDetails true seçilirse toplam puan gösterilir.
      if (printDetails == true) {
        print('Toplam Puan: $points\n');
      }
    }

    print("Ölçek Bitti. Toplam Puanınız: $points");
    return points;
  }
  //ölçeklerin aralık değerlerini gösteren compareConditions methodu
  List compareConditions(int resultOfUser, List<String> degreeOfResults, List<int> degreeOfResultRange) {
    List<List<int>> subLists = [];
    List<Map> displayedResults = [];
    String finalResultName = "";

    // Aralıklar kadar alt listeler oluştur
    for (int i = 0; i < degreeOfResultRange.length; i += 2) {
      if (i + 1 < degreeOfResultRange.length) {
        subLists.add([degreeOfResultRange[i], degreeOfResultRange[i + 1]]);
      }
    }

    // Kullanıcı yanıtının ilgili range e düştüğünü bulma
    for (int i = 0; i < subLists.length; i++) {
      int lowerBound = subLists[i][0];
      int upperBound = subLists[i][1];

      if (resultOfUser >= lowerBound && resultOfUser <= upperBound) {
        finalResultName = "${degreeOfResults[i]}: $lowerBound ile $upperBound arasında.";
      }


      if (i < degreeOfResults.length) {
        displayedResults.add({degreeOfResults[i]: subLists[i]});
      }
    }

    return [finalResultName, displayedResults];
  }


  }
  //Big five için özelleştirilmiş ve Survey'den kalıtım almış SurveyBigFive classı
class SurveyBigFive extends Survey {
  //Big five ın faktör puanlarını tutan değişkenler ve Survey classından kalıtımla alınan değişkenler

  int extroversionPoint;
  int agreeablenessPoint;
  int conscientiousnessPoint;
  int neuroticismPoint;
  int opennessToExperience;

  SurveyBigFive(
      String title,
      String instruction,
      List<String> questions,
      List<int> options,
      List<int> trueAnswers,
      List<int> selectedAnswers,
      List<bool> reversedAnswers,
      this.extroversionPoint,
      this.agreeablenessPoint,
      this.conscientiousnessPoint,
      this.neuroticismPoint,
      this.opennessToExperience)
      : super(title, instruction, questions, options, trueAnswers, selectedAnswers, reversedAnswers);

  // sumResults1 ile ilgili faktör skorlarının sonuçlarını döndürme
  List<int> sumResults1(int maxScore, bool printDetails) {
    int totalScore = 0;
    List<List<int>> factorList = [];

    // her bir fatörü tutan sublistlerden oluşan liste
    factorList = [
      // Extroversion
      [
        selectedAnswers[0],
        selectedAnswers[5],
        selectedAnswers[10],
        selectedAnswers[15],
        selectedAnswers[20],
        selectedAnswers[25],
        selectedAnswers[30],
        selectedAnswers[35],
        selectedAnswers[40],
        selectedAnswers[45]
      ],
      // Agreeableness
      [
        selectedAnswers[1],
        selectedAnswers[6],
        selectedAnswers[11],
        selectedAnswers[16],
        selectedAnswers[21],
        selectedAnswers[26],
        selectedAnswers[31],
        selectedAnswers[36],
        selectedAnswers[41],
        selectedAnswers[46]
      ],
      // Conscientiousness
      [
        selectedAnswers[2],
        selectedAnswers[7],
        selectedAnswers[12],
        selectedAnswers[17],
        selectedAnswers[22],
        selectedAnswers[27],
        selectedAnswers[32],
        selectedAnswers[37],
        selectedAnswers[42],
        selectedAnswers[47]
      ],
      // Neuroticism
      [
        selectedAnswers[3],
        selectedAnswers[8],
        selectedAnswers[13],
        selectedAnswers[18],
        selectedAnswers[23],
        selectedAnswers[28],
        selectedAnswers[33],
        selectedAnswers[38],
        selectedAnswers[43],
        selectedAnswers[48]
      ],
      // Open to experience
      [
        selectedAnswers[4],
        selectedAnswers[9],
        selectedAnswers[14],
        selectedAnswers[19],
        selectedAnswers[24],
        selectedAnswers[29],
        selectedAnswers[34],
        selectedAnswers[39],
        selectedAnswers[44],
        selectedAnswers[49]
      ]
    ];

    //faktörleri hesaplama
    extroversionPoint = 20 +
        factorList[0][0] -
        factorList[0][1] +
        factorList[0][2] -
        factorList[0][3] +
        factorList[0][4] -
        factorList[0][5] +
        factorList[0][6] -
        factorList[0][7] +
        factorList[0][8] -
        factorList[0][9];

    agreeablenessPoint = 14 -
        factorList[1][0] +
        factorList[1][1] -
        factorList[1][2] +
        factorList[1][3] -
        factorList[1][4] +
        factorList[1][5] -
        factorList[1][6] +
        factorList[1][7] +
        factorList[1][8] +
        factorList[1][9];

    conscientiousnessPoint = 14 +
        factorList[2][0] -
        factorList[2][1] +
        factorList[2][2] -
        factorList[2][3] +
        factorList[2][4] -
        factorList[2][5] +
        factorList[2][6] -
        factorList[2][7] +
        factorList[2][8] +
        factorList[2][9];

    neuroticismPoint = 38 -
        factorList[3][0] +
        factorList[3][1] -
        factorList[3][2] +
        factorList[3][3] -
        factorList[3][4] -
        factorList[3][5] -
        factorList[3][6] -
        factorList[3][7] -
        factorList[3][8] -
        factorList[3][9];

    opennessToExperience = 8 +
        factorList[4][0] -
        factorList[4][1] +
        factorList[4][2] -
        factorList[4][3] +
        factorList[4][4] +
        factorList[4][5] +
        factorList[4][6] +
        factorList[4][7] +
        factorList[4][8] +
        factorList[4][9];

    // Toplam sonuç
    totalScore = extroversionPoint +
        agreeablenessPoint +
        conscientiousnessPoint +
        neuroticismPoint +
        opennessToExperience;

    // printDetails true seçilirse her faktörü bastır
    if (printDetails == true) {
      print('Extroversion Score: $extroversionPoint');
      print('Agreeableness Score: $agreeablenessPoint');
      print('Conscientiousness Score: $conscientiousnessPoint');
      print('Neuroticism Score: $neuroticismPoint');
      print('Openness to Experience Score: $opennessToExperience');
      print('Total Score: $totalScore\n');
    }

    // fakötr sonuçlarını döndürür
    return [
      extroversionPoint,
      agreeablenessPoint,
      conscientiousnessPoint,
      neuroticismPoint,
      opennessToExperience
    ];
  }
}



