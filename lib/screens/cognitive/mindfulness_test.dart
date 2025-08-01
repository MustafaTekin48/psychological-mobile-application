import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/cognitive/CognitiveTestHelper.dart';

class MindfulnessTest extends StatefulWidget {
  const MindfulnessTest({super.key});

  @override
  State<MindfulnessTest> createState() => _MindfulnessTestState();
}

class _MindfulnessTestState extends State<MindfulnessTest> {
  Random random = Random();
  late List<int> options;
  late List<String> questionsList;
  late List<int> selectedAnswers;
  late List<List<int>> shuffledOptionsList; // Her soru için karıştırılmış seçenekler

  late List<String> tempList = [];
  late List<String> finalList = [];
  late List<List<String>> optionText;
  late List<String> trueAnswers;
  late List<List<String>>  explanation;

  int questionIndex = 0;

  late CognitiveTest cognitiveTest;

  String onScreenText =
      "Bu test, olumsuz veya işlevsiz düşünceleri daha yapıcı ve olumlu bir şekilde yeniden çerçeveleme becerinizi değerlendirmek için hazırlanmıştır. "
      "Her soruda size bir durum veya otomatik düşünce sunulacaktır. Amacınız, bu düşünceyi daha sağlıklı ve işlevsel bir bakış açısıyla yeniden yapılandırmaktır. "
      "Aşağıda verilen sorularda ilk aklınıza gelen yanıtı verin ve olabildiğince içgörüyle düşünmeye çalışın. Hazırsanız başlayalım!";

  String exitText = "Test Bitti. Çıkış Yapabilirsiniz.";

  @override
  void initState() {
    super.initState();

    questionsList = [
      "İş yerinde bir sunum yaptın ve birkaç küçük hata yaptın. Sunum sonrası kendini kötü hissediyorsun. Ne düşünürsün?",
      "Arkadaşın seni hafta sonu planlarına davet etmedi. Ne düşünürsün?",
      "Sınavın için çok çalıştın ama sınavda bazı soruları yapamadın. Ne düşünürsün?",
      "Topluluk önünde konuşma yapman gerekiyor ve çok gerginsin. Ne düşünürsün?",
      "Trafikte biri önünü kesti ve çok sinirlendin. Ne düşünürsün?",
      "Kendini mutsuz hissediyorsun ve hayatın anlamsız geliyor. Ne düşünürsün?",
      "İş yerinde bir projeyi yetiştirememe ihtimalin var ve streslisin. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",
      "Bir arkadaşın seni eleştirdi ve bu seni çok üzdü. Ne düşünürsün?",
      "Bir hedefin için çok çalıştın ama başarılı olamadın. Ne düşünürsün?",
      "Bir toplantıda fikrini söyledin ama kimse desteklemedi. Ne düşünürsün?",
      "Bir arkadaşın seni aramadı ve bu seni üzdü. Ne düşünürsün?",
      "Bir hobi edinmek istiyorsun ama başlamak için cesaretin yok. Ne düşünürsün?",
      "Bir yarışmaya katıldın ama kazanamadın. Ne düşünürsün?",
      "Bir projeyi tamamlamak için çok çalıştın ama sonuç beklentilerini karşılamadı. Ne düşünürsün?",];
    optionText= [
      ["Herkes benim beceriksiz olduğumu düşünüyor, kesin işten atılacağım.", "Küçük hatalar yaptım ama genel olarak sunum iyi geçti, daha iyisini yapabilirim.", "Hiçbir zaman iyi bir sunum yapamayacağım, bu iş bana göre değil.", "Herkes mükemmel olmalı, ben başarısızım."],
      ["Beni artık sevmiyor, kesin benimle zaman geçirmek istemiyor.", "Belki meşguldür ya da unutmuştur, ona ulaşıp sormak en iyisi.", "Kimse beni sevmiyor, hep dışlanıyorum.", "Herkes bana karşı, kimse beni önemsemiyor."],
      ["Bu sınavda başarısız oldum, her şey berbat.", "Bazı soruları yapamadım ama genel olarak iyi geçti, daha iyisini yapabilirim.", "Hiçbir zaman başarılı olamayacağım, boşuna çalışıyorum.", "Herkes benden daha iyi, ben yetersizim."],
      ["Kesin heyecandan rezil olacağım, herkes benimle dalga geçecek.", "Heyecanlı olmak normal, elimden geleni yapacağım.", "Hiçbir zaman topluluk önünde konuşamayacağım, bu benim için imkansız.", "Herkes benden daha iyi konuşuyor, ben yetersizim."],
      ["Bu adam kesin beni sinir etmek için yaptı, herkes bana karşı.", "Belki acelesi vardır, herkes hata yapabilir.", "İnsanlar çok bencil, kimse kurallara uymuyor.", "Bu tür insanlar yüzünden trafik çekilmez oluyor, hepsi aynı."],
      ["Hayatım hiçbir zaman düzelmeyecek, hep böyle mutsuz olacağım.", "Şu an zor bir dönemden geçiyorum ama bu geçici, kendime iyi bakmalıyım.", "Kimse beni anlamıyor, herkes bana karşı.", "Hiçbir şey beni mutlu edemez, her şey boş."],
      ["Kesin yetiştiremeyeceğim, her şey berbat olacak.", "Zamanı iyi kullanırsam yetiştirebilirim, elimden geleni yapacağım.", "Bu projeyi yetiştiremezsem işten atılırım, her şey biter.", "Ben beceriksizin tekiyim, hiçbir şeyi doğru düzgün yapamıyorum."],
      ["Beni sevmiyor, kesin benden nefret ediyor.", "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.", "Kimse beni anlamıyor, herkes bana karşı.", "Herkes beni eleştiriyor, hiçbir şeyi doğru yapamıyorum."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.", "Herkes benden daha iyi, ben yetersizim.", "Başarısız oldum, artık hiçbir şey yolunda gitmeyecek."],
      ["Kimse beni ciddiye almıyor, fikirlerim değersiz.", "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.", "Herkes bana karşı, kimse beni önemsemiyor.", "Toplantılarda hiçbir zaman sözüm geçmeyecek."],
      ["Beni artık sevmiyor, kesin benimle ilgilenmiyor.", "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.", "Kimse beni önemsemiyor, herkes bana karşı.", "Herkes beni unutuyor, hiçbir zaman değer görmeyeceğim."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna denemeyeyim.", "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.", "Herkes benden daha yetenekli, ben yetersizim.", "Hiçbir şeyi doğru düzgün yapamıyorum, boşuna uğraşmayayım."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna uğraşıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Kazanamadığım için her şey berbat oldu."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Proje başarısız oldu, her şey berbat."],
      ["Beni sevmiyor, kesin benden nefret ediyor.", "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.", "Kimse beni anlamıyor, herkes bana karşı.", "Herkes beni eleştiriyor, hiçbir şeyi doğru yapamıyorum."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.", "Herkes benden daha iyi, ben yetersizim.", "Başarısız oldum, artık hiçbir şey yolunda gitmeyecek."],
      ["Kimse beni ciddiye almıyor, fikirlerim değersiz.", "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.", "Herkes bana karşı, kimse beni önemsemiyor.", "Toplantılarda hiçbir zaman sözüm geçmeyecek."],
      ["Beni artık sevmiyor, kesin benimle ilgilenmiyor.", "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.", "Kimse beni önemsemiyor, herkes bana karşı.", "Herkes beni unutuyor, hiçbir zaman değer görmeyeceğim."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna denemeyeyim.", "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.", "Herkes benden daha yetenekli, ben yetersizim.", "Hiçbir şeyi doğru düzgün yapamıyorum, boşuna uğraşmayayım."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna uğraşıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Kazanamadığım için her şey berbat oldu."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Proje başarısız oldu, her şey berbat."],
      ["Beni sevmiyor, kesin benden nefret ediyor.", "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.", "Kimse beni anlamıyor, herkes bana karşı.", "Herkes beni eleştiriyor, hiçbir şeyi doğru yapamıyorum."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.", "Herkes benden daha iyi, ben yetersizim.", "Başarısız oldum, artık hiçbir şey yolunda gitmeyecek."],
      ["Kimse beni ciddiye almıyor, fikirlerim değersiz.", "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.", "Herkes bana karşı, kimse beni önemsemiyor.", "Toplantılarda hiçbir zaman sözüm geçmeyecek."],
      ["Beni artık sevmiyor, kesin benimle ilgilenmiyor.", "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.", "Kimse beni önemsemiyor, herkes bana karşı.", "Herkes beni unutuyor, hiçbir zaman değer görmeyeceğim."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna denemeyeyim.", "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.", "Herkes benden daha yetenekli, ben yetersizim.", "Hiçbir şeyi doğru düzgün yapamıyorum, boşuna uğraşmayayım."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna uğraşıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Kazanamadığım için her şey berbat oldu."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Proje başarısız oldu, her şey berbat."],
      ["Beni sevmiyor, kesin benden nefret ediyor.", "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.", "Kimse beni anlamıyor, herkes bana karşı.", "Herkes beni eleştiriyor, hiçbir şeyi doğru yapamıyorum."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.", "Herkes benden daha iyi, ben yetersizim.", "Başarısız oldum, artık hiçbir şey yolunda gitmeyecek."],
      ["Kimse beni ciddiye almıyor, fikirlerim değersiz.", "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.", "Herkes bana karşı, kimse beni önemsemiyor.", "Toplantılarda hiçbir zaman sözüm geçmeyecek."],
      ["Beni artık sevmiyor, kesin benimle ilgilenmiyor.", "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.", "Kimse beni önemsemiyor, herkes bana karşı.", "Herkes beni unutuyor, hiçbir zaman değer görmeyeceğim."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna denemeyeyim.", "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.", "Herkes benden daha yetenekli, ben yetersizim.", "Hiçbir şeyi doğru düzgün yapamıyorum, boşuna uğraşmayayım."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna uğraşıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Kazanamadığım için her şey berbat oldu."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Proje başarısız oldu, her şey berbat."],
      ["Beni sevmiyor, kesin benden nefret ediyor.", "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.", "Kimse beni anlamıyor, herkes bana karşı.", "Herkes beni eleştiriyor, hiçbir şeyi doğru yapamıyorum."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.", "Herkes benden daha iyi, ben yetersizim.", "Başarısız oldum, artık hiçbir şey yolunda gitmeyecek."],
      ["Kimse beni ciddiye almıyor, fikirlerim değersiz.", "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.", "Herkes bana karşı, kimse beni önemsemiyor.", "Toplantılarda hiçbir zaman sözüm geçmeyecek."],
      ["Beni artık sevmiyor, kesin benimle ilgilenmiyor.", "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.", "Kimse beni önemsemiyor, herkes bana karşı.", "Herkes beni unutuyor, hiçbir zaman değer görmeyeceğim."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna denemeyeyim.", "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.", "Herkes benden daha yetenekli, ben yetersizim.", "Hiçbir şeyi doğru düzgün yapamıyorum, boşuna uğraşmayayım."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna uğraşıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Kazanamadığım için her şey berbat oldu."],
      ["Hiçbir zaman başarılı olamayacağım, boşuna çabalıyorum.", "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.", "Herkes benden daha iyi, ben yetersizim.", "Proje başarısız oldu, her şey berbat."],
    ];
    trueAnswers= ["Küçük hatalar yaptım ama genel olarak sunum iyi geçti, daha iyisini yapabilirim.",
      "Belki meşguldür ya da unutmuştur, ona ulaşıp sormak en iyisi.",
      "Bazı soruları yapamadım ama genel olarak iyi geçti, daha iyisini yapabilirim.",
      "Heyecanlı olmak normal, elimden geleni yapacağım.",
      "Belki acelesi vardır, herkes hata yapabilir.",
      "Şu an zor bir dönemden geçiyorum ama bu geçici, kendime iyi bakmalıyım.",
      "Zamanı iyi kullanırsam yetiştirebilirim, elimden geleni yapacağım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",
      "Bu sefer olmadı ama daha fazla çalışıp tekrar deneyebilirim.",
      "Belki fikrimi daha iyi ifade edebilirim, bir dahakine daha hazırlıklı olurum.",
      "Belki meşguldür, ona ulaşıp halini hatırını sorabilirim.",
      "Küçük adımlarla başlayabilirim, herkes bir yerden başlar.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Bu sefer olmadı ama deneyim kazandım, bir dahakine daha iyi hazırlanırım.",
      "Belki haklı olabilir, bunu düşünüp kendimi geliştirebilirim.",];
    explanation= [
      [
        "Felaketleştirme ve zihinsel filtre: Küçük hatalar abartılıyor.",
        "Aşırı genelleme: Bir deneyimden yola çıkarak gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Mükemmeliyetçilik: Gerçekçi olmayan standartlar."
      ],
      [
        "Keyfi çıkarsama: Başkalarının davranışları kişisel algılanıyor.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarılıyor.",
        "Felaketleştirme: Durum abartılıyor."
      ],
      [
        "Felaketleştirme: Sınavın tamamen başarısız geçtiği yanılgısı.",
        "Aşırı genelleme: Bir sınavdan yola çıkarak gelecekteki tüm sınavlar hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor."
      ],
      [
        "Felaketleştirme: Henüz gerçekleşmemiş bir olay hakkında olumsuz bir senaryo kuruluyor.",
        "Aşırı genelleme: Bir deneyimden yola çıkarak gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılanıyor.",
        "Aşırı genelleme: Bir kişinin davranışından yola çıkarak tüm insanlar hakkında olumsuz bir genelleme yapılıyor.",
        "Genelleme: Öfke birikimi ve genel bir olumsuzluğa odaklanma."
      ],
      [
        "Felaketleştirme: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuluyor.",
        "Kişiselleştirme: Başkalarının seni anlamadığı yanılgısına neden oluyor.",
        "Umutsuzluk: Hayatın tamamen anlamsız olduğu yanılgısına neden oluyor."
      ],
      [
        "Felaketleştirme: Olumsuz bir sonuç öngörülüyor.",
        "Felaketleştirme: Aşırı genelleme yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuyorsun."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Felaketleştirme: Durumu abartıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuyorsun."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Felaketleştirme: Durumu abartıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuyorsun."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Felaketleştirme: Durumu abartıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuyorsun."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Felaketleştirme: Durumu abartıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir öngörüde bulunuyorsun."
      ],
      [
        "Kişiselleştirme: Başkalarının davranışlarını kişisel algılıyorsun.",
        "Aşırı genelleme: Bir olaydan yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Felaketleştirme: Durumu abartıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Kendini etiketleme: Gerçekçi olmayan bir şekilde kendini yargılıyorsun."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Umutsuzluk: Gelecekteki tüm deneyimler hakkında olumsuz bir genelleme yapılıyor.",
        "Kıyaslama: Başkalarıyla kıyas yapılıyor.",
        "Felaketleştirme: Bir başarısızlık, her şeyin kötü gideceği anlamına gelmiyor."
      ],
      [
        "Kişiselleştirme: Eleştiriyi kişisel algılıyorsun.",
        "Aşırı genelleme: Bir kişinin eleştirisinden yola çıkarak genel bir sonuç çıkarıyorsun.",
        "Zihinsel filtre: Olumsuz olaylara odaklanıyorsun."
      ],];


    options = [0, 1, 2, 3];
    selectedAnswers = List<int>.filled(questionsList.length, -1); // Başlangıçta hiçbir şey seçilmemiş olsun

    cognitiveTest = CognitiveTest(
      options,
      questionsList,
      selectedAnswers,
      tempList,
    );
    finalList = cognitiveTest.CrateTestQuestions(); // Rastgele 11 soru seç

    // Seçilen 11 soru için seçenekleri karıştır
    shuffledOptionsList = [];
    for (int i = 0; i < finalList.length; i++) {
      shuffledOptionsList.add(shuffleOptions(options));
    }
  }

  bool validateAnswer() {
    if (selectedAnswers[questionIndex] == -1) {
      // Eğer cevap verilmemişse
      return false;
    }
    return true;
  }

  List<int> shuffleOptions(List<int> options) {
    final shuffledIndices = List<int>.from(options)..shuffle(random);
    return shuffledIndices;
  }
  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Çıkış"),
        content: const Text("Testten çıkmak istiyor musunuz?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Hayır"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("Evet"),
          ),
        ],
      ),
    ) ??
        false; // Eğer kullanıcı diyaloğu kapatırsa varsayılan olarak false döner.
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;

        bool exitApp = await showExitDialog(context);
        if (exitApp) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.lightGreen,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'Zihinsel Farkındalık Testi',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body:
        Center(
          child: SingleChildScrollView(
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Soru metni
                  if (questionIndex == 0)
                    Text(
                      onScreenText,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                    )
                  else if (questionIndex > 0 &&
                      (selectedAnswers[questionIndex] == -1 ||
                          optionText[questionsList.indexOf(finalList[questionIndex])][selectedAnswers[questionIndex]] ==
                              trueAnswers[questionsList.indexOf(finalList[questionIndex])]))
                    Text(
                      finalList[questionIndex],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
      
                  const SizedBox(height: 10),
      
                  // Radyo seçenekleri (cevap verilmemişse veya doğru cevap verilmişse)
                  if (questionIndex > 0 &&
                      (selectedAnswers[questionIndex] == -1 ||
                          optionText[questionsList.indexOf(finalList[questionIndex])][selectedAnswers[questionIndex]] ==
                              trueAnswers[questionsList.indexOf(finalList[questionIndex])]))
                    ...shuffledOptionsList[questionIndex].map((option) {
                      String optionAnswer = optionText[questionsList.indexOf(finalList[questionIndex])][option];
                      return RadioListTile<int>(
                        activeColor: Colors.black,
                        title: Text(
                          optionAnswer,
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: option,
                        groupValue: selectedAnswers[questionIndex],
                        onChanged: (int? value) {
                          setState(() {
                            selectedAnswers[questionIndex] = value!;
                          });
                        },
                      );
                    }).toList(),
      
                  // Doğru cevap ve açıklama (yanlış cevap durumunda)
                  if (questionIndex > 0 &&
                      selectedAnswers[questionIndex] != -1 &&
                      optionText[questionsList.indexOf(finalList[questionIndex])][selectedAnswers[questionIndex]] !=
                          trueAnswers[questionsList.indexOf(finalList[questionIndex])])
                    Column(
                      children: [
                        Text(
                          "Doğru Cevap: ${trueAnswers[questionsList.indexOf(finalList[questionIndex])]}",
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          explanation[questionsList.indexOf(finalList[questionIndex])][0],
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          explanation[questionsList.indexOf(finalList[questionIndex])][1],
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          explanation[questionsList.indexOf(finalList[questionIndex])][2],
                          style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
      
                  const SizedBox(height: 5),
      
                  // İleri butonu
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (!validateAnswer() && questionIndex > 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lütfen Soruyu Cevaplayın!'),
                              duration: Duration(seconds: 2), // Mesajın görünme süresi
                            ),
                          );
                        } else {
                          if (questionIndex < finalList.length - 1) {
                            questionIndex++;
                          } else {
                            onScreenText = exitText;
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, size: 35, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),

    ),
    );
  }
}