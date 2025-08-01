import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:flutter_application_1/screens/home/home_page.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:core';
//import 'package:sozluk/sozluk.dart';


class PsychotherapistScreen extends StatefulWidget {
  @override
  _PsychotherapistScreenState createState() => _PsychotherapistScreenState();
}

class _PsychotherapistScreenState extends State<PsychotherapistScreen> {
  String textFromFile= '';
  List<String> wordList = []; // Kelimelerin saklanacağı liste
  final Map<String, String> gramer = {
    "ben": "sen",
    "benim": "senin",
    "beni": "seni",
    "senin": "benim",
    "sen": "ben",
    "seni": "beni",
    "yapıyorum": "yapıyorsun",
    "yapıyorsun": "yapıyorum",
    "geldim": "geldin",
    "geldin": "geldim",
    "olacağım": "olacaksın",
    "olacaksın": "olacağım",
    "hissediyorum": "hissediyorsun",
    "hissediyorsun": "hissediyorum",
    "düşünüyorum": "düşünüyorsun",
    "düşünüyorsun": "düşünüyorum",
    "yapmak istiyorum": "yapmak istiyorsun",
    "yapmak istiyorsun": "yapmak istiyorum",
    "istiyorum": "istiyorsun",
    "istiyorsun": "istiyorum"
  };
  final Map<String, List<String>> patternResponses = {
    r"(.*) hissediyorum$": [
      "Hissettiklerin çok önemli. Bu konuda daha fazla paylaşmak ister misin?",
      "Bu hislerini anlamak önemli. Bu konuda biraz konuşmak ister misin?",
      "Duygularını ifade etmen çok değerli. Bu his üzerine biraz daha konuşabilir miyiz?"
    ],
    r"(.*) düşünüyorum$": [
      "Düşüncelerin önemli, ne hakkında düşünüyorsun?",
      "Bu düşüncen hakkında biraz daha konuşmak ister misin?",
      "Düşüncelerin üzerine konuşmak seni rahatlatabilir. Ne düşündüğünü anlatmak ister misin?"
    ],
    r"(.*) merak ediyorum$": [
      "Merak ettiklerini anlamak için buradayım. Bu konuyu biraz açmak ister misin?",
      "Merak ettiklerin üzerine konuşmak güzel olur. Ne merak ediyorsun?",
      "Merak duygusu keşfetmek için harika bir başlangıçtır. Bu konuda neler düşünüyorsun?"
    ]
  };
  final Map<String, List<String>> keywordsResponses = {
    'hissetmek': [
      "Bu konuda hislerini paylaşman önemli.",
      "Duygularını ifade etmek seni rahatlatabilir. Hissiyatını biraz daha açar mısın?"
    ],
    'düşünmek': [
      "Düşüncelerin üzerine konuşmak iyi bir fikir. Ne düşünüyorsun?",
      "Bunu biraz daha açmak ister misin?"
    ],
    'merak': [
      "Merak ettiğin konu hakkında daha fazla bilgi verebilirim.",
      "Merak etmek, öğrenmeye başlamak için harika bir adımdır."
    ]
  };
  Map<String, String> wordMap = {};


  Future<void> getData() async {
    String response = await rootBundle.loadString('assets/data/dict.xlsx'); // Dosyayı okuma
    setState(() {
      wordMap = Map.fromEntries(
          response.split('\n').map((line) {
            final parts = line.split(','); // Virgüle göre ayır
            if (parts.length >= 2) {
              return MapEntry(parts[0].trim(), parts[1].trim()); // İlk kısım key, ikinci kısım value
            }
            return null; // Hatalı satırlar için null döndür
          }).whereType<MapEntry<String, String>>().toList());
;
      print('Sözlük yüklendi:');
      print(wordMap.entries.take(10).toList()); // İlk 10 key-value çiftini yazdırma
    });
  }

  final List<String> _messages = []; // Mesajları tutan liste
  final TextEditingController _controller = TextEditingController(); // Mesaj giriş denetleyicisi
  int timeleft = 300; // 1 dakika 30 saniye olarak başlatılıyor
  int minutes = 5; // Başlangıç dakikası
  int seconds = 0; // Başlangıç saniyesi
  String correctedWord = '';

  List<List<dynamic>> kurallar = [
    ["(.*)merhaba(.*)", [
      "Merhaba. Sizinle konuşmak için buradayım. Probleminizi ya da konuşmak istediğiniz konuyu paylaşmak ister misiniz?",
      "Selam! Burada olduğum için mutluyum. Nasılsınız?",
      "Merhaba! Sizinle sohbet etmek benim için önemli. Hangi konuda konuşmak istersiniz?"
    ]],
    ["(.*)nasılsın(.*)", [
      "Ben bir programım, duygularım yok ama sizinle ilgilenmek için buradayım. Sizin duygularınız nasıl?",
      "Benim bir ruh halim yok, ama sizin için buradayım. Siz nasılsınız?",
      "İyiyim, teşekkürler! Siz kendinizi nasıl hissediyorsunuz?"
    ]],
    ["(.*)geçmişle barışmak(.*)", [
      "Geçmişle barışma çabalarınız neler? Bu süreçte nasıl hissettiğinizi merak ediyorum.",
      "Geçmişle ilgili hislerinizi çözmek için neler yapıyorsunuz? Bu konuyu daha fazla açmak ister misiniz?",
      "Geçmişte yaşadıklarınızla barışmak zorlayıcı olabilir. Bu süreçte destek almak ister misiniz?"
    ]],
    ["(.*)kaygı(.*)", [
      "Kaygı, birçok insanın yaşadığı bir duygu. Sizin için bu duygunun anlamı nedir?",
      "Kaygı ile başa çıkma yollarınızı merak ediyorum. Bu konuda neler düşünüyor musunuz?",
      "Kaygı duyduğunuzda kendinizi nasıl hissediyorsunuz? Bu konuda daha fazla paylaşmak ister misiniz?"
    ]],
    ["(.*)yalnızlık(.*)", [
      "Yalnızlık duygusuyla nasıl başa çıkıyorsunuz? Bu konuyu daha derinlemesine incelemek ister misiniz?",
      "Yalnız hissettiğinizde neler yapıyorsunuz? Bu duygu hakkında daha fazla konuşmak ister misiniz?",
      "Yalnızlık bazen zorlayıcı olabilir. Bu konuda düşünceleriniz neler?"
    ]],
    ["(.*)güçsüz(.*)", [
      "Güçsüz hissettiğinizde kendinizi nasıl ifade ediyorsunuz? Bu duyguyu paylaşmak ister misiniz?",
      "Güçsüzlük hissi zorlayıcı olabilir. Bu durumu açmak sizin için yararlı olabilir.",
      "Güçsüz hissettiğinizi belirttiniz. Bu duygunun kökenine inmek ister misiniz?"
    ]],
    ["(.*)üzgünüm(.*)", [
      "Üzgün hissetmenizi anlıyorum. Sizi üzen şey hakkında konuşmak ister misiniz?",
      "Bu durumda üzgün olduğunuzu duymak üzücü. Bu konuyu açmak ister misiniz?",
      "Üzgün hissettiğinizi duymak zor. Bu konuyu paylaşmak ister misiniz?"
    ]],
    ["(.*)mükemmel(.*)", [
      "Mükemmel olmak konusunda hissettiklerinizi merak ediyorum. Mükemmeliyetçilik sizin için ne ifade ediyor?",
      "Mükemmel olma isteği bazen baskı yaratabilir. Bu konuyu daha derinlemesine incelemek ister misiniz?",
      "Mükemmeliyetçilik ile ilgili düşünceleriniz neler? Bu durum hayatınızı nasıl etkiliyor?"
    ]],
    ["(.*)üzgün(.*)", [
      "Üzgün hissettiğinizi duyduğuma üzüldüm. Bu konuda konuşmak size iyi gelebilir mi?",
      "Üzgün hissettiğinizi anlıyorum. Bu duygularınızı paylaşmak isterseniz buradayım.",
      "Üzgün olduğunuzu belirtmişsiniz. Bu durumu daha fazla açmak ister misiniz?"
    ]],
    ["(.*)mutlu(.*)", [
      "Mutlu hissettiğinizi duymak güzel! Bu mutluluğun kaynağını paylaşmak ister misiniz?",
      "Mutluluk harika bir duygu! Neden mutlu olduğunuzu düşünüyorsunuz?",
      "Mutlu hissettiğinizi duymak sevindirici! Bu mutluluğun sebepleri neler?"
    ]],
    ["(.*)sinirli(.*)", [
      "Sinirli olmanızın sebebini anlamak isterim. Bu konuda daha fazla paylaşmak ister misiniz?",
      "Sinirli olduğunuzu anlıyorum. Bu durumu açmak sizin için yararlı olabilir.",
      "Sinirli hissettiğinizi duyduğuma üzüldüm. Bunun sebeplerini paylaşmak ister misiniz?"
    ]],
    ["(.*)kızgın(.*)", [
      "Kızgın hissettiğinizi anlıyorum. Kızgınlığınızın sebeplerini paylaşmak ister misiniz?",
      "Kızgın hissettiğinizi duymak zor. Bu duygularınızı anlatmak isterseniz buradayım.",
      "Kızgın olduğunuzu belirtmişsiniz. Bu konuda daha fazla bilgi almak ister misiniz?"
    ]],
    ["(.*)endişeli(.*)", [
      "Endişeli hissettiğinizi duymak üzücü. Endişelerinizi anlatmak size iyi gelebilir mi?",
      "Endişeli olduğunuzu belirtmişsiniz. Bu konuda daha fazla konuşmak ister misiniz?",
      "Endişeli hissettiğinizi anlıyorum. Endişelerinizin nedenlerini paylaşmak ister misiniz?"
    ]],
    ["(.*)stresli(.*)", [
      "Stresli olduğunuzu belirtmişsiniz. Bu stresin kaynağı hakkında konuşmak isterseniz buradayım.",
      "Stresli hissettiğinizi duyduğuma üzüldüm. Stres kaynaklarınızı paylaşmak ister misiniz?",
      "Stresli olduğunuzu duymak zor. Bu konuda daha fazla bilgi paylaşmak ister misiniz?"
    ]],
    ["(.*)mutluluk(.*)", [
      "Mutluluk hakkında konuşmak güzel! Bu mutluluğu neyle ilişkili buluyorsunuz?",
      "Mutluluk, hayatın önemli bir parçası. Bu konuda daha fazla düşünmek ister misiniz?",
      "Mutluluk ile ilgili hislerinizi paylaşmak harika olabilir. Neler düşünüyorsunuz?"
    ]],
    ["(.*)yalnız(.*)", [
      "Yalnız hissettiğinizi anlıyorum. Yalnızlığın getirdiği duygular hakkında paylaşmak ister misiniz?",
      "Yalnız hissettiğinizi belirtmişsiniz. Bu konuda daha fazla açılmak ister misiniz?",
      "Yalnızlık zorlayıcı olabilir. Bu duygularınızı paylaşmak isterseniz buradayım."
    ]],
    ["(.*)hayal kırıklığı(.*)", [
      "Hayal kırıklığı yaşadığınızı duyduğuma üzüldüm. Bu konuyu daha fazla açmak ister misiniz?",
      "Hayal kırıklığı zor bir durum. Bu konuda daha fazla konuşmak isterseniz buradayım.",
      "Hayal kırıklığı hissetmek zorlayıcı olabilir. Bunun nedenlerini paylaşmak ister misiniz?"
    ]],
    ["(.*)aile(.*)", [
      "Aile ile ilgili duygular bazen karmaşık olabilir. Bu konuda konuşmak ister misiniz?",
      "Aile ilişkileri üzerinde düşünmek önemli olabilir. Ailenizle ilgili neler düşünüyorsunuz?",
      "Aile hakkında konuşmak her zaman yararlı olabilir. Duygularınızı paylaşmak ister misiniz?"
    ]],
    ["(.*)arkadaş(.*)", [
      "Arkadaşlık ilişkileri bazen zorlayıcı olabilir. Arkadaşlıklarınız hakkında konuşmak size iyi gelebilir mi?",
      "Arkadaşlarınızla olan ilişkilerinizi değerlendirmek güzel olabilir. Bu konuda daha fazla açılmak ister misiniz?",
      "Arkadaşlık ilişkileri hakkında konuşmak faydalı olabilir. Neler düşünüyorsunuz?"
    ]],
    ["(.*)seviyorum(.*)", [
      "Sevgi güçlü bir duygu. Bu konuda daha fazla paylaşmak ister misiniz?",
      "Sevgi, insan ilişkilerinin merkezinde yer alır. Bu konuda düşüncelerinizi paylaşmak ister misiniz?",
      "Sevgi hakkında konuşmak güzel olabilir. Bu konuda daha fazla bilgi almak ister misiniz?"
    ]],
    ["(.*)nefret(.*)", [
      "Nefret gibi güçlü duygular bazen zorlayıcı olabilir. Bu konuda ne hissettiğinizi paylaşmak ister misiniz?",
      "Nefret, karmaşık bir duygu. Bu konuda daha fazla açılmak ister misiniz?",
      "Nefret hissetmek zorlayıcı olabilir. Bu duygularınızı anlatmak isterseniz buradayım."
    ]],
    ["(.*)kendim(.*)", [
      "Kendinizi anlatmak, kim olduğunuz hakkında konuşmak rahatlatıcı olabilir. Neler düşünüyorsunuz?",
      "Kendinizi ifade etmek önemlidir. Bu konuda daha fazla düşünmek ister misiniz?",
      "Kendinizle ilgili paylaşımda bulunmak iyi bir başlangıç olabilir. Neler düşünüyorsunuz?"
    ]],
    ["(evet)", [
      "Lütfen devam edin, daha fazla paylaşmak ister misiniz?",
      "Evet, lütfen daha fazla detay verin.",
      "Devam etmek harika olur! Neler söylemek istersiniz?"
    ]],
    ["(hayır)", [
      "Tamam, başka bir şey konuşmak ister misiniz?",
      "Anladım, başka bir konuyu ele alalım mı?",
      "Tamamdır, başka bir şey hakkında konuşmak isterseniz buradayım."
    ]],
    ["(.*)başarısız(.*)", [
      "Başarısızlık zorlayıcı olabilir. Bu duyguyla ilgili daha fazla paylaşmak ister misiniz?",
      "Herkes zaman zaman başarısızlık hissi yaşayabilir. Bu konuda konuşmak rahatlatıcı olabilir.",
      "Başarısızlık, büyüme ve öğrenme fırsatı olabilir. Bu durumu nasıl değerlendiriyorsunuz?"
    ]],
    ["(.*)başarı(.*)", [
      "Başarı sizin için ne anlama geliyor? Bu konuda düşüncelerinizi paylaşmak ister misiniz?",
      "Başarı ile ilgili hislerinizi merak ediyorum. Başarısızlık duygusuyla nasıl başa çıkıyorsunuz?",
      "Başarıyı nasıl tanımlıyorsunuz? Bu tanım sizin hayatınızı nasıl etkiliyor?"
    ]],
    ["(.*)güvensizlik(.*)", [
      "Güvensizlik duygusu zorlayıcı olabilir. Bu hislerle başa çıkma yollarını düşünmek ister misiniz?",
      "Güvensizlik, birçok kişinin yaşadığı bir duygudur. Bu konuda konuşmak size iyi gelebilir.",
      "Güvensiz hissettiğinizi duyduğuma üzüldüm. Bu durumu daha fazla açmak ister misiniz?"
    ]],
    ["(.*)şüphe(.*)", [
      "Şüphe duygusu karmaşık bir durumdur. Bu konuda daha fazla düşünmek ister misiniz?",
      "Şüphe, bazen önemli bir düşünme sürecinin parçası olabilir. Neler düşünüyorsunuz?",
      "Şüphe hissetmek, karar verme sürecini etkileyebilir. Bu durumu nasıl yaşıyorsunuz?"
    ]],
    ["(.*)yetersizlik(.*)", [
      "Yetersizlik hissi zorlayıcı olabilir. Bu konuyu açmak isteyebilir misiniz?",
      "Yetersizlik duygusu birçok insanda görülebilir. Bu konuda nasıl hissediyorsunuz?",
      "Yetersiz hissettiğinizi anlıyorum. Bu konuda daha fazla paylaşmak ister misiniz?"
    ]],
    ["(.*)destek(.*)", [
      "Destek almak önemlidir. Bu konuda neler düşünüyorsunuz?",
      "Destek bulmak zorlayıcı olabilir. Sizi destekleyen biriyle konuşmak ister misiniz?",
      "Destek ihtiyacınızı hissettiğinizi duyduğuma üzüldüm. Bu konuda daha fazla konuşmak isteyebilir misiniz?"
    ]],
    ["(.*)hayal(.*)", [
      "Hayal kurmak önemlidir. Hayalleriniz hakkında daha fazla paylaşmak ister misiniz?",
      "Hayalleriniz, hedeflerinizi şekillendirebilir. Neler hayal ediyorsunuz?",
      "Hayal kurmak, motivasyonunuzu artırabilir. Hayalleriniz neler?"
    ]],
    ["(.*)hayal kırıklığı(.*)", [
      "Hayal kırıklığı yaşadığınızda duygularınızı nasıl yönetiyorsunuz? Bu durumu açmak ister misiniz?",
      "Hayal kırıklığı zordur. Bu duygunun sizi nasıl etkilediğini düşünüyorsunuz?",
      "Hayal kırıklığı yaşamak zorlayıcı olabilir. Bu duyguyu daha fazla paylaşmak ister misiniz?"
    ]],
    ["(.*)özsaygı(.*)", [
      "Özsaygı sizin için ne ifade ediyor? Kendinize nasıl değer veriyorsunuz?",
      "Özsaygı konusunda yaşadığınız zorluklar neler? Bu konuyu açmak isterseniz buradayım.",
      "Özsaygıyı artırmak için neler yapıyorsunuz? Bu süreçte nasıl hissediyorsunuz?"
    ]],
    ["(.*)geçmiş(.*)", [
      "Geçmişle ilgili düşünmek zorlayıcı olabilir. Bu konuda daha fazla paylaşmak ister misiniz?",
      "Geçmiş deneyimleriniz sizi şekillendirmiştir. Bu konuda neler düşünüyorsunuz?",
      "Geçmiş, zaman zaman hatırlanması zor bir konudur. Bu durumu nasıl değerlendiriyorsunuz?"
    ]],
    ["(.*)gelecek(.*)", [
      "Gelecek hakkında düşünmek heyecan verici olabilir. Gelecekle ilgili neler hayal ediyorsunuz?",
      "Gelecek kaygıları, birçok kişinin yaşadığı bir durumdur. Bu konuda konuşmak ister misiniz?",
      "Gelecekle ilgili hayalleriniz ve hedefleriniz neler? Bunları paylaşmak ister misiniz?"
    ]],

    ["(.*)bağlantı(.*)", [
      "Bağlantı kurmak, insan ilişkilerinde önemlidir. Bu konuda neler düşünüyorsunuz?",
      "Bağlantı hissetmek, insanları daha iyi anlamaya yardımcı olabilir. Bu konuda daha fazla paylaşmak ister misiniz?",
      "Bağlantı kurmak zorlayıcı olabilir. İlişkilerinizi nasıl değerlendiriyorsunuz?"
    ]],

    ["(.*)konuşmak istemiyorum(.*)",
      ["Tamam, istemediğiniz bir şey hakkında konuşmak zorunda değilsiniz. Başka bir şey düşünmek ister misiniz?",
        "Anlıyorum, istemiyorsanız zorlamayalım. Sizi rahatsız eden başka bir konu var mı?", "İstemediğinizi duyduğuma üzüldüm. Belki başka bir konu hakkında konuşmak istersiniz?"]],

    /*["(.*)", [
      "Bunu daha detaylı anlatmak ister misiniz?",
      "Bu konuda daha fazla düşünmenizi sağlayan nedir?",
      "Bu konu hakkında ne hissettiğinizi anlamaya çalışıyorum. Lütfen devam edin."
    ]],*/
  ];
  // Anahtar kelimelere göre yanıtlar
  // Stopword'leri hariç tutarak girdiyi işleyelim
  final List<String> turkishStopwords = [
    've', 'ya', 'bir', 'ben', 'sen', 'o', 'bu', 'de', 'da', 'ile', 'için', 'gibi', 'ama', 'ya da'
  ];


  @override
  void initState() {
    super.initState();
    countDownTimer(); // Sayacın başlatılması
    getData();




  }
  String? transformInputToQuestion(String userInput) {
    // Stopwords hariç kelimeleri listeye ayır
    List<String> words = userInput
        .toLowerCase()
        .split(' ')
        .where((word) => !turkishStopwords.contains(word))
        .toList();

    // Anahtar kelime kontrolü
    for (var word in words) {
      if (keywordsResponses.containsKey(word)) {
        return _getRandomResponse(keywordsResponses[word]!);
      }
    }

    // Regex kalıplarını kontrol et
    for (var pattern in patternResponses.keys) {
      final regExp = RegExp(pattern, caseSensitive: false);
      if (regExp.hasMatch(userInput)) {
        return _getRandomResponse(patternResponses[pattern]!);
      }
    }

    // Hiçbiri uymuyorsa, son iki kelimeyle soru oluştur
    if (words.length >= 2) {
      return "Sence ${words[words.length - 2]} ${words[words.length - 1]} nedir?";
    }

    return "Bu konuda daha fazla konuşmak ister misiniz?"; // Minimum içerik durumu
  }

  String _getRandomResponse(List<String> responses) {
    return responses[Random().nextInt(responses.length)];
  }

  // En Yakın Kelimeyi Bulma

  String selectFromResponses(String input) {
    // Transformation Rules
    input = duzeltme(input);

    // Check rules for a match
    for (var kural in kurallar) {
      RegExp desen = RegExp(kural[0]);
      if (desen.hasMatch(input.replaceAll(RegExp(r'[.!]$'), ''))) {
        List<String> mesajlar = kural[1]; // Eşleşen kuralın yanıtlarını al
        return mesajlar[Random().nextInt(mesajlar.length)];
      }
    }

    // Eğer kurallarla eşleşme yoksa transformInputToQuestion'ı kullan
    String? soru = transformInputToQuestion(input);
    if (soru != null) {
      return soru; // Soru üretildiyse döndür
    }

    // Varsayılan cevap (Çok nadir kullanılır)
    return "Bu konuda daha fazla konuşmak ister misiniz?";
  }

  String duzeltme(String kelime) {
    // Kelimeyi küçük harfe çevir ve boşlukla ayırarak kelimeler listesine dönüştür
    List<String> kelimeler = kelime.toLowerCase().split(" ");

    // Kelimeleri kontrol et ve gramer kurallarına göre düzelt
    for (int i = 0; i < kelimeler.length; i++) {
      if (gramer.containsKey(kelimeler[i])) {
        kelimeler[i] = gramer[kelimeler[i]]!;
      }
    }

    // Kelimeleri tekrar birleştir ve sonucu döndür
    return kelimeler.join(" ");
  }

  String _generateResponse(String input) {
    // 1. Adım: Sözlükten özel yanıt sorgula
    String? customResponse = sorgulaVeCevapla(input);
    if (customResponse != null) {
      return customResponse;
    }

    // 2. Adım: Kurallarda bulunmayan kelimeleri kontrol ederek yanıt oluştur
    customResponse = selectFromResponses(input);
    if (customResponse.isNotEmpty) {
      return customResponse;
    }

    // 3. Adım: Anahtar kelime veya son kelimelerle soru oluştur
    String? transformedQuestion = transformInputToQuestion(input);
    if (transformedQuestion != null) {
      return transformedQuestion;
    }

    // 4. Adım: Genel Pattern Cevapları
    for (var pattern in patternResponses.keys) {
      final regExp = RegExp(pattern, caseSensitive: false);
      if (regExp.hasMatch(input.toLowerCase())) {
        return _getRandomResponse(patternResponses[pattern]!);
      }
    }

    // Varsayılan cevap
    return "Bu konuda daha fazla konuşmak ister misiniz?";
  }

  // `sorgulaVeCevapla` Fonksiyonu
  String? sorgulaVeCevapla(String userInput) {
    List<String> triggerPhrases = [
      'nedir', 'anlatır mısın', 'bilgi verir misin', 'anlat', 'bilgi ver'
    ];

    for (var phrase in triggerPhrases) {
      if (userInput.toLowerCase().contains(phrase)) {
        // Trigger kelimesini çıkar ve kalan kısmı temizle
        String cleanedInput = userInput.toLowerCase().replaceAll(phrase, '').trim();

        if (cleanedInput.isNotEmpty) {
          // En yakın anahtar kelimeyi bul
          String? closestMatch = wordMap.keys.firstWhere(
                (key) => key.toLowerCase().contains(cleanedInput),
            orElse: () => '',
          );

          if (closestMatch.isNotEmpty) {
            // En yakın eşleşmeyi döndür
            return '$closestMatch: ${wordMap[closestMatch]}';
          }
        }
      }
    }

    return null; // Hiçbir eşleşme bulunamazsa null döndür
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    const maxLength = 200; // Maximum character length

    if (text.isNotEmpty && text.length <= maxLength) {
      setState(() {
        correctedWord = text;  // Just find the closest word (without Levenshtein)
        _messages.insert(0, correctedWord); // Add user's message to the list
      });

      // Generate bot response and add it to the list
      String botResponse = _generateResponse(text);
      setState(() {
        _messages.insert(0, botResponse); // Add bot response to the list
      });

      _controller.clear(); // Clear the TextField
    } else if (text.length > maxLength) {
      // Alert when the message exceeds the character limit
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mesajınız ${maxLength} karakteri geçemez.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: AppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text("Psikoterapist"),
        actions: [
          Center(
            child: Text(
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 30),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length, // Mesaj sayısı
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: index % 2 == 0 ? Colors.blue[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // İkonları uç noktalara yerleştir
                      children: [
                        // Sağ taraf için ikon (Icons.face solda olacak)
                        index % 2 != 0
                            ? Icon(
                          Icons.face,
                          color: Colors.grey,
                        )
                            : SizedBox.shrink(), // Sağ tarafı boş bırak

                        // Mesaj metni
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10), // Mesaj ve ikon arası boşluk
                            child: Text(
                              message,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),

                        // Sol taraf için ikon (Icons.person sağda olacak)
                        index % 2 == 0
                            ? Icon(
                          Icons.person,
                          color: Colors.blue,
                        )
                            : SizedBox.shrink(), // Sol tarafı boş bırak
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLength: 150,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Mesajınızı yazın...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.text, // Türkçe karakterler için yazı tipi
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: _sendMessage,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Denetleyiciyi serbest bırak
    super.dispose();
  }
  // Levenshtein Mesafesi Hesaplama


  void countDownTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeleft--; // Her saniye azalır

        // Dakika ve saniyeyi hesapla
        minutes = timeleft ~/ 60; // Dakika
        seconds = timeleft % 60;  // Saniye

        if (timeleft <= 0) {
          timer.cancel(); // Geri sayım bittiğinde durdur

          // Dialog göster
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Uyarı"),
                content: Text("Terapi Süreniz Bitti"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    },
                    child: Text("Geri Dön"),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }


}


