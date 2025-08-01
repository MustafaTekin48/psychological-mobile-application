import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/meditations/MeditationJournals/meditation_journal.dart';
import 'package:flutter_application_1/screens/meditations/meditation_list.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditasyon Ekranı'),
        centerTitle: true, // Optionally center the title
        backgroundColor: Colors.greenAccent, // AppBar background color
        foregroundColor: Colors.black, // AppBar text color
      ),
      body:

      Column( // Changed to Column to allow for full height usage
        children: <Widget>[
          Expanded( // Use Expanded to make the Row fill the remaining vertical space
            child: Row( // Use Row to place buttons side-by-side
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make buttons stretch vertically
              children: <Widget>[
                Expanded( // First button takes half the width
                  child: Padding(
                    padding: const EdgeInsets.all(1.0), // Add padding around the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the meditation calendar screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => meditation_journal()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600, // Button background color
                        foregroundColor: Colors.white, // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        elevation: 5, // Add a shadow
                      ),
                      child: const Text(
                        'Meditasyon günlüğü',
                        textAlign: TextAlign.center, // Center text within the button
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                ),
                Expanded( // Second button takes the other half of the width
                  child: Padding(
                    padding: const EdgeInsets.all(1.0), // Add padding around the button
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to the meditation list screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => meditation_list()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade600, // Button background color (green teal)
                        foregroundColor: Colors.white, // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        elevation: 5, // Add a shadow
                      ),
                      child: const Text(
                        'Meditasyon listesi',
                        textAlign: TextAlign.center, // Center text within the button
                        style: TextStyle(fontSize: 18), // Larger text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
