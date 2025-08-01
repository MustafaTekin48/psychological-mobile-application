import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/home/screens/MeditationScreen.dart';
import 'package:provider/provider.dart';
import 'MeditationJournalProvider.dart';

import 'meditation_callendar.dart';
import 'meditation_stats.dart';

class meditation_journal extends StatelessWidget {
  final String? selectedEmotion;
  final bool meditationCompletedToday;
  final String? meditationThemeName;

  const meditation_journal({
    super.key,
    this.selectedEmotion,
    this.meditationCompletedToday = false,
    this.meditationThemeName,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MeditationJournalProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meditasyon Günlüğüm',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MeditationJournal(
          selectedEmotion: selectedEmotion,
          meditationCompletedToday: meditationCompletedToday,
          meditationThemeName: meditationThemeName,
        ),
      ),
    );
  }
}

class MeditationJournal extends StatelessWidget {
  final String? selectedEmotion;
  final bool meditationCompletedToday;
  final String? meditationThemeName;

  const MeditationJournal({
    super.key,
    this.selectedEmotion,
    this.meditationCompletedToday = false,
    this.meditationThemeName,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavBar(
      selectedEmotion: selectedEmotion,
      meditationCompletedToday: meditationCompletedToday,
      meditationThemeName: meditationThemeName,
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final String? selectedEmotion;
  final bool meditationCompletedToday;
  final String? meditationThemeName;

  const BottomNavBar({
    super.key,
    this.selectedEmotion,
    this.meditationCompletedToday = false,
    this.meditationThemeName,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.selectedEmotion != null) {
      _selectedIndex = 1;
    } else if (widget.meditationCompletedToday) {
      _selectedIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      meditation_callendar(
        meditationCompletedToday: widget.meditationCompletedToday,
        selectedEmotion: widget.selectedEmotion,
        meditationThemeName: widget.meditationThemeName,
      ),
      meditation_stats(selectedEmotion: widget.selectedEmotion),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MeditationScreen()),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text('Meditasyon Günlüğüm', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF3F3D56),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Takvim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'İstatistikler',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Color(0xFF3F3D56),
      ),
    );
  }
}