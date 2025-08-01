import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/screens/MeditationScreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_application_1/screens/home/screens/basic_emotion_analysis_screen.dart';
import 'package:flutter_application_1/screens/home/screens/daily_behavior_input_screen.dart';
import 'package:flutter_application_1/screens/home/screens/diary_screen.dart';
import 'package:flutter_application_1/screens/home/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/home/screens/psychological_scales_screen.dart';
import 'package:flutter_application_1/screens/home/screens/psychology_dictionary_screen.dart';
import 'package:flutter_application_1/screens/home/screens/psychotherapist_screen.dart';
import 'package:flutter_application_1/screens/home/screens/settings_screen.dart';
import '../../constant/show_logout_dialog.dart';
import 'package:flutter_application_1/screens/home/screens/camera_screen.dart';
import 'package:flutter_application_1/screens/home/screens/face_detection_screen.dart';

import '../meditations/meditation_list.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Map<String, dynamic>> _gridItems = [
    {"title": "Psikolojik Ölçekler", "icon": Icons.assignment, "screen": PsychologicalScalesScreen()},
    {"title": "Psikoloji Sözlüğü", "icon": Icons.book, "screen": PsychologyDictionaryScreen()},
    {"title": "Günlük", "icon": Icons.calendar_today, "screen": DiaryScreen()},
    {"title": "Psikoterapist", "icon": Icons.person, "screen": PsychotherapistScreen()},
    {"title": "Duygu Analizi", "icon": Icons.camera, "screen": FaceDetectionScreen()},  // Duygu Analizi sekmesi FaceDetectionScreen'e yönlendiriliyor
    {"title": "Profil", "icon": Icons.account_circle, "screen": ProfileScreen()},
    {"title": "Davranış Girdileri", "icon": Icons.edit, "screen": DailyBehaviorInputScreen()},
    {"title": "Meditasyon", "icon": Icons.face_2_rounded, "screen": MeditationScreen()},
    {"title": "Ayarlar", "icon": Icons.settings, "screen": SettingsScreen()},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Ana Sayfa', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              showLogoutDialog(context); // showLogoutDialog fonksiyonunu çağırıyoruz
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          itemCount: _gridItems.length,
          itemBuilder: (BuildContext context, int index) => _buildCard(
            context,
            _gridItems[index]['title'] as String,
            _gridItems[index]['icon'] as IconData,
            _gridItems[index]['screen'] as Widget,
          ),
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        height: 140,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E5EC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: const Offset(6, 6),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            const BoxShadow(
              color: Colors.white,
              offset: Offset(-6, -6),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
