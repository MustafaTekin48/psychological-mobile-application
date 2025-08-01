import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/diary/screens/emotion_selection_screen.dart';
import '../../diary/screens/calendar_screen.dart';
import '../../diary/screens/home_screen.dart';
import '../home_page.dart';



class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavBar();

  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _diaryEntries = []; // Günlük girişlerini tutan liste

  final List<Widget> _pages = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      HomeScreen(diaryEntries: _diaryEntries),
      CalendarScreen(diaryEntries: _diaryEntries),
      EmotionSelectionScreen(
        onNewEntry: (newEntry) {
          setState(() {
            _diaryEntries.add(newEntry); // Yeni entry eklenince liste güncelleniyor
            _selectedIndex = 0; // Home ekranına dön
          });
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Günlüklerim', style: TextStyle(color: Colors.black87),),
        backgroundColor: Color(0xFF3F3D56),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Günlük',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black87,
        backgroundColor: Color(0xFF3F3D56),
      ),
    );
  }
}
