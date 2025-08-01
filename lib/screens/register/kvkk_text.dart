import 'package:flutter/material.dart';

class KVKKScreen extends StatelessWidget {
  const KVKKScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Kullanıcı Verileri Toplama ve İşleme Onam Metni'),
      content: const SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Değerli Kullanıcımız,\n\n'
              'Uygulamamızın sunduğu hizmetleri daha iyi bir şekilde sunabilmek, deneyiminizi kişiselleştirmek ve geliştirmek amacıyla bazı kişisel verilerinizi toplamamız ve işlememiz gerekmektedir. Aşağıda, hangi tür verileri topladığımız ve bu verilerin nasıl işlendiğine dair bilgilendirme bulabilirsiniz:\n\n'
              'Toplanacak Veriler:\n'
              '1. Görsel Veriler: Profil fotoğrafı ve diğer görsel içerikler\n'
              '2. Metinsel Veriler: Girdiğiniz yazılı içerikler ve yorumlar\n'
              '3. Davranışsal Veriler: Uygulama içerisindeki kullanım alışkanlıklarınız, tıklama geçmişiniz ve etkileşimleriniz\n'
              '4. Sosyodemografik Veriler: Yaş, cinsiyet, eğitim durumu, meslek, ikamet ettiğiniz şehir gibi kişisel bilgiler\n\n'
              'Verilerin Toplanma ve İşlenme Amaçları:\n'
              '1. Uygulamanın işlevselliğini ve kullanım kolaylığını artırmak\n'
              '2. Size özel içerik ve öneriler sunmak\n'
              '3. Hizmetlerimizi kişiselleştirmek ve iyileştirmek\n'
              '4. Güvenlik ve kullanıcı doğrulama süreçlerini geliştirmek\n'
              '5. Yasal yükümlülüklere uygun olarak saklama ve raporlama yapmak\n\n'
              'Veri Saklama Süresi: Toplanan kişisel veriler, ilgili yasal yükümlülüklere uygun olarak belirli bir süre boyunca saklanacak ve bu sürenin sonunda güvenli bir şekilde silinecektir.\n\n'
              'Haklarınız: 6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) kapsamında, aşağıdaki haklara sahipsiniz:\n'
              '1. Kişisel verilerinizin işlenip işlenmediğini öğrenme\n'
              '2. İşlenen veriler hakkında bilgi talep etme\n'
              '3. Verilerin düzeltilmesini veya silinmesini talep etme\n'
              '4. Verilerinizin işlenmesine itiraz etme\n'
              '5. Kanuni haklarınızı kullanma\n\n'
              'Onayınız: Bu onam metnini okuyarak, yukarıda belirtilen amaçlarla kişisel verilerinizin toplanmasına ve işlenmesine izin verdiğinizi kabul edersiniz. Onay vermemeniz durumunda, uygulamamızın bazı özelliklerini kullanamayabilirsiniz.\n',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Evet, onaylıyorum'),
          onPressed: () {
            Navigator.of(context).pop(true);  // Onayı kabul et
          },
        ),
        TextButton(

          child: Text('Hayır, onaylamıyorum'),
          onPressed: () {
            Navigator.of(context).pop(false);  // Onayı reddet
          },
        ),
      ],
    );
  }
}
