import 'package:flutter/material.dart';

class EmotionButton extends StatelessWidget {
  final String emotion;
  final Color color;
  final VoidCallback onTap;

  EmotionButton({required this.emotion, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        child: Center(
          child: Text(
            emotion,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
