import 'package:flutter/material.dart';

class WarningDialog {
  static Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: const Column(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 60), // Uyarı ikonu
              SizedBox(height: 10),
              Text(
                'Dikkat!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Lütfen KVKK Sözleşmesini onaylayın.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF3F3D56), // Buton yazı rengi
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Buton iç boşluk
                ),
                child: const Text(
                  'Tamam',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
