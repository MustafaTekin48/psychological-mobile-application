import 'package:flutter/material.dart';

import '../../scales/screens/beck_anxiety_screen.dart';
import '../../scales/screens/beck_depression_screen.dart';
import '../../scales/screens/beck_hopelessness_screen.dart';
import '../../scales/screens/emotional_stress_screen.dart';
import '../../scales/screens/short_mood_screen.dart';
import '../../scales/screens/short_social_anxiety.dart';
import '../../scales/screens/sources_explanations.dart';

class PsychologicalScalesScreen extends StatelessWidget {
  const PsychologicalScalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Psikolojik Ölçekler",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            _buildScaleCard(
              context,
              title: 'CES-D Depresyon Ölçeği',
              description: 'Bu ölçek, bireylerin depresyon düzeyini değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: BeckDepressionInv(),
            ),
            _buildScaleCard(
              context,
              title: 'Beck Umutsuzluk Ölçeği',
              description: 'Bu ölçek, bireylerin umutsuzluk düzeyini değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: BeckHopelessnessInv(),
            ),
            _buildScaleCard(
              context,
              title: 'Beck Anksiyete Envanteri',
              description: 'Bu envanter, bireylerin anksiyete düzeyini değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: BeckAnxietyInv(),
            ),
            _buildScaleCard(
              context,
              title: 'Algılanan Stres Ölçeği',
              description: 'Bu ölçek, bireylerin stres düzeyini değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: EmotionalStressInv(),
            ),
            _buildScaleCard(
              context,
              title: 'Warwick-Edinburgh Mental İyi Oluş Ölçeği Kısa Formu',
              description: 'Bu form, bireylerin mental iyi oluş düzeyini değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: ShortMoodInv(),
            ),
            _buildScaleCard(
              context,
              title: 'Büyük 5 Kişilik Özelliği Ölçeği',
              description: 'Bu ölçek, bireylerin kişiliğini 5 faktör düzeyinde değerlendirmek için kullanılır.',
              icon: Icons.assignment,
              screen: BigFiveInv(),
            ),
            const SizedBox(height: 16), // Ekstra boşluk
            _buildSpecialCard(
              context,
              title: 'Kaynaklar ve Açıklamalar',
              description: 'Ölçekler ile ilgili ek bilgi ve kaynaklar burada yer alır.',
              icon: Icons.info_outline,
              screen: SourcesExplanations(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaleCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Widget screen,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.teal[50],
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.teal[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.teal,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialCard(
      BuildContext context, {
        required String title,
        required String description,
        required IconData icon,
        required Widget screen,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.blueGrey[50],
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 50, color: Colors.blueGrey[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueGrey,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
