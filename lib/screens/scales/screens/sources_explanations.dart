import 'package:flutter/material.dart';


//Text rich içerisinde style ile siyah renk ve boyutu ayarlandı ve 6 ölçeğin açıklaması ve kaynak bilgileri bulunuyor.
class SourcesExplanations extends StatelessWidget {
  const SourcesExplanations({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Kaynaklar ve Açıklamalar"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Kenarlardan boşluk veriyoruz
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '1) The Center for Epidemiologic Studies Short Depression Scale Türkçe Uyarlaması\n\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: 'Epidemiyolojik Araştırmalar Merkezi Kısa Depresyon Ölçeği (CES-D-R 10), orijinal CES-D ölçeğinin kısaltılmış bir versiyonudur ve özellikle bir popülasyondaki depresif belirtileri değerlendirmek için tasarlanmıştır. CES-D-R 10, geçen hafta yaşanan semptomların sıklığını değerlendiren 10 madde içermektedir.\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nCES-D-R 10 un Türkçe versiyonu Türkçe konuşan topluluklarda kullanılmak üzere uyarlanmıştır. Bu adaptasyon tipik olarak şunları içerir:',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),

                    TextSpan(
                      text: '\nCES-D-R 10, klinik ortamlarda, araştırma çalışmalarında ve halk sağlığı değerlendirmelerinde, Türkiye’deki ve diğer Türkçe konuşulan topluluklardaki yetişkinlerde depresif belirtilerin taranması amacıyla kullanılmaktadır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKatılımcılar, Likert ölçeği kullanarak (örneğin, "nadiren veya hiçbir zaman"dan "çoğu zaman veya her zaman"a kadar) üzgün hissetmek, uyku sorunu yaşamak veya yorgunluk yaşamak gibi çeşitli depresif belirtileri ne sıklıkta yaşadıklarını belirtirler.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nYanıtlar, depresif semptom şiddetinin genel bir ölçüsünü sağlamak üzere puanlanır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nEpidemiyolojik çalışmalarda depresyon için daha fazla değerlendirme veya müdahale gerektirebilecek kişileri belirlemek için sıklıkla kullanılır.\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Marmara, M., Çakın, M., & Uysal, N. (2020). "Validity and Reliability of the Turkish Version of the Center for Epidemiologic Studies Depression Scale (CES-D) in Turkish Population." Anadolu Psikiyatri Dergisi, 21(1), 14-20.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n2) Beck Umutsuzluk Ölçeği Türkçe Uyarlaması\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeck Umutsuzluk Ölçeği (BHS), bireyin genellikle depresyon ve intihar düşüncesiyle bağlantılı olan umutsuzluk düzeyini ölçmek için tasarlanmış, yaygın olarak kullanılan bir psikolojik değerlendirme aracıdır. BHS nin Türkçe validasyonu, Türkçe konuşan topluluklarda uygulanmasına izin vermektedir.\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeck Umutsuzluk Ölçeği Türkçeye çevrilmiş ve Türkçe konuşanlar arasında geçerliliği ve anlaşılmasını sağlamak amacıyla kültürel olarak uyarlanmıştır.\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Aydın, M. ve ark. (2015). "Beck Umutsuzluk Ölçeğinin Psikometrik Özellikleri: Türkçe Versiyonu." Duygulanım Bozuklukları Dergisi, 173, 45-51. DOI: 10.1016/j.jad.2014.09.026.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n3) Beck Anksiyete Ölçeği Türkçe Uyarlaması\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeck Anksiyete Envanteri (BAI), yetişkinlerde ve ergenlerde anksiyete belirtilerinin şiddetini ölçmek için tasarlanmış bir öz bildirim anketidir. Dr. Aaron T. Beck ve meslektaşları tarafından geliştirilmiştir ve klinik ve araştırma ortamlarında yaygın olarak kullanılmaktadır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBAI, her biri belirli bir kaygı belirtisini tanımlayan 21 maddeden oluşur. Katılımcılar geçen hafta boyunca her semptomdan ne kadar rahatsız olduklarını 0 dan (hiç) 3 e (ciddi, zar zor dayanabildim) kadar bir ölçekte derecelendiriyorlar.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nMaddelerden alınan puanlar toplanarak toplam puan elde edilir; yüksek puanlar, kaygı şiddetinin arttığını gösterir. Toplam puan 0 ile 63 arasında değişebilir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBAI kesin bir tanı koymaz ancak kaygı düzeyinin değerlendirilmesine yardımcı olur. Puanlar genel olarak şu şekilde yorumlanır: '
                          '0-7: Minimal kaygı 8-15: Hafif kaygı 16-25: Orta düzeyde kaygı 26-63: Şiddetli kaygı',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBAI, dil ve kavramların kültürel açıdan uygun ve anlaşılır olmasına dikkat edilerek Türkçeye çevrildi.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Ulusoy, M., Fişek, G. ve Erkmen, H. (1998). "Beck Kaygı Envanteri: Türkçe Versiyonu." Klinik Psikiyatri Dergisi, 59(6), 32-36.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n4) Algılanan Stres Ölçeği Türkçe Uyarlaması\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nAlgılanan Stres Ölçeği (PSS), bireyin stres algısını değerlendirmek için tasarlanmış yaygın olarak kullanılan psikolojik bir araçtır. Bir kişinin hayatındaki durumların ne ölçüde stresli olarak değerlendirildiğini ölçer. PSS, stresi veya ilgili durumları teşhis etmek için değil, katılımcıların hayatlarını ne kadar tahmin edilemez, kontrol edilemez ve bunaltıcı bulduklarını değerlendirmek için tasarlanmıştır. ',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n PSS nin en sık kullanılan versiyonu 10 maddelik ölçektir (PSS-10), ancak 14 maddelik (PSS-14) ve 4 maddelik (PSS-4) versiyonları da vardır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nPSS, geçen aydaki stres duygularını 0 dan (hiçbir zaman) 4 e (çok sık) kadar değişen 5 li Likert ölçeği kullanarak ölçer.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nPSS, geçen aydaki stres duygularını 0 dan (hiçbir zaman) 4 e (çok sık) kadar değişen 5 li Likert ölçeği kullanarak ölçer.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nPSS-10 için puanlar 0 ile 40 arasında değişmektedir; yüksek puanlar algılanan stres düzeyinin yüksek olduğunu göstermektedir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBazı maddeler ters puanlanır (örneğin, olumlu deneyimleri tanımlayan maddeler) ve toplam puan, tüm maddelerin toplanmasıyla hesaplanır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nPSS nin Türkçe versiyonu hem araştırma hem de klinik ortamlarda genel nüfusun yanı sıra öğrenciler, hastalar ve çalışanlar gibi belirli gruplardaki stres düzeylerini değerlendirmek için yaygın olarak kullanılmaktadır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Eskin, M., Harlak, H., Demirkıran, F. ve Dereboy, Ç. (2013). "Algılanan Stres Ölçeğinin Türkçeye Uyarlanması: Geçerlik ve Güvenirlik Analizi." Yeni/Yeni Sempozyum Dergisi, 51(3), 132-140. ',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n5) Warwick-Edinburgh Mental Refah Ölçeği Türkçe Uyarlaması\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nWarwick-Edinburgh Mental Refah Ölçeği (WEMWBS), genel nüfusun zihinsel refahını ölçmek için geliştirilmiş bir araçtır. Mental refahın hem hedonik (mutluluk duyguları ve yaşam doyumu) ​​hem de eudaimonik (olumlu psikolojik işlevsellik, kendini gerçekleştirme ve amaç duygusu) yönlerini değerlendirir. Ölçek genellikle halk sağlığı, psikoloji ve araştırmalarda müdahaleleri değerlendirmek, refahı izlemek ve nüfusun ruh sağlığını anlamak için kullanılır.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nWEMWBS, 2006 yılında Warwick ve Edinburgh Üniversitelerindeki araştırmacılar tarafından NHS Health Scotland ile işbirliği içinde geliştirildi. Sadece akıl hastalığının yokluğunun değil, pozitif ruh sağlığının ölçülmesinin de önemli olduğunun giderek artan bir şekilde anlaşılmasına yanıt olarak oluşturulmuştur.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nOrijinal WEMWBS, her biri olumlu bir şekilde ifade edilen ve son iki haftadaki zihinsel sağlıkla ilgili olan 14 maddeden oluşmaktadır. Katılımcılardan her bir ifadeyi ne sıklıkta yaşadıklarını 5 li Likert ölçeğinde (1 = hiçbir zaman ila 5 = her zaman) derecelendirmeleri istenir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nToplam puan, tüm maddelere ilişkin puanların toplanmasıyla elde edilir; yüksek puanlar, zihinsel iyilik düzeyinin yüksek olduğunu gösterir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nWEMWBS, halk sağlığında nüfusun zihinsel sağlığını izlemek ve müdahalelerin etkinliğini değerlendirmek için yaygın olarak kullanılmaktadır. Bireylerin veya grupların refahını, özellikle ruh sağlığını geliştirme programlarında, terapötik müdahalelerde ve işyeri refah değerlendirmelerinde değerlendirir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nSıkıntı, depresyon veya kaygıya odaklanan birçok zihinsel sağlık önleminin aksine WEMWBS, zihinsel sağlık ve refahın olumlu yönlerini vurgulayarak onu bütünsel bir araç haline getirir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nSıkıntı, depresyon veya kaygıya odaklanan birçok zihinsel sağlık önleminin aksine WEMWBS, zihinsel sağlık ve refahın olumlu yönlerini vurgulayarak onu bütünsel bir araç haline getirir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nWEMWBS farklı yaş gruplarında, sosyal bağlamlarda ve kültürlerde kullanıma uygundur.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Tennant, R., Hiller, L., Fishwick, R., Platt, S., Joseph, S., Weich, S., Stewart-Brown, S. (2007). "Warwick-Edinburgh Mental Refah Ölçeği (WEMWBS): Geliştirme ve Birleşik Krallık doğrulaması." Sağlık ve Yaşam Kalitesi Sonuçları, 5(63), DOI: 10.1186/1477-7525-5-63.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\n6) Büyük 5 Kişilik Özelliği Ölçeği\n',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeş Büyük Kişilik Özellikleri Ölçeği (Beş Faktörlü Model veya Beş Büyük Envanter - BFI olarak da bilinir), insan kişiliğinin beş ana boyutunu ölçen popüler bir psikolojik değerlendirme aracıdır: Deneyime Açıklık, Vicdanlılık, Dışadönüklük, Uyumluluk ve Nevrotiklik (genellikle OCEAN kısaltmasıyla anılır).',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeş Büyük Kişilik Özellikleri Ölçeği (Beş Faktörlü Model veya Beş Büyük Envanter - BFI olarak da bilinir), insan kişiliğinin beş ana boyutunu ölçen popüler bir psikolojik değerlendirme aracıdır: Deneyime Açıklık, Vicdanlılık, Dışadönüklük, Uyumluluk ve Nevrotiklik (genellikle OCEAN kısaltmasıyla anılır).',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeş Büyük Kişilik Özelliği Ölçeğinin Türkçeye uyarlanması, aracın farklı kültürlerde güvenirliğini ve geçerliliğini koruyarak Türkçe konuşan toplumlarda etkin bir şekilde kullanılabilmesini sağlıyor.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nBeş Büyük Kişilik Özelliği Ölçeğinin Türkçeye uyarlanması, aracın farklı kültürlerde güvenirliğini ve geçerliliğini koruyarak Türkçe konuşan toplumlarda etkin bir şekilde kullanılabilmesini sağlıyor.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nBeş Büyük Kişilik Özelliğine Genel Bakış:',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\t\t\tDeneyime Açıklık: Entelektüel merakı, yaratıcılığı ve yenilik ve çeşitlilik tercihini yansıtır. Açıklık düzeyi yüksek bireyler yaratıcı olma ve yeni fikirlere açık olma eğilimindedirler.'
                          '\n\n\t\t\tVicdanlılık: Öz disiplin, organizasyon ve hedefe yönelik davranışlarla ilişkilidir. Vicdanlılıkta yüksek puan alan insanlar genellikle güvenilir ve verimlidir.'
                          '\n\n\t\t\tDışadönüklük: Sosyallik, atılganlık ve konuşkanlığı içerir. Yüksek dışadönüklük, dışa dönük ve enerjik birisini gösterir.'
                          '\n\n\t\t\tUyumluluk: Güven, fedakarlık, nezaket ve şefkat gibi özelliklerle ilgilidir. Yüksek uyumluluk işbirlikçi ve şefkatli bir doğayı yansıtır.'
                          '\n\n\t\t\tNevrotiklik: Duygusal dengesizliği ve kaygı, öfke veya depresyon gibi olumsuz duyguları deneyimleme eğilimini gösterir.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\n\nBeş Büyük Envanteri Türkçeye çevrilerek dilin anlaşılır ve kültürel açıdan uygun olması sağlandı.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nTürkiye Büyük Beş Ölçeği kişilik, klinik psikoloji, örgütsel psikoloji ve sosyal psikoloji gibi çeşitli bağlamlarda kullanılmaktadır. Kişilik özelliklerinin değerlendirilmesine ve iş performansı, ilişki memnuniyeti ve zihinsel sağlık gibi sonuçların tahmin edilmesine yardımcı olur.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: '\nKaynak: Sümer, N., Lajunen, T. ve Özkan, T. (2005). "Beş Büyük Kişilik Özelliği ve Karayolu Trafik Kazaları: Bağlamsal Aracı Modelinin Test Edilmesi." Kaza Analizi ve Önleme, 37(6), 987-997.',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
