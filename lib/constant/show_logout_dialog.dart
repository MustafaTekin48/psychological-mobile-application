// lib/utils/show_logout_dialog.dart

import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../screens/login/login_screen.dart';

void showLogoutDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.warning,  // Uyarı ikonu
    animType: AnimType.bottomSlide,  // Alt kısımdan yukarıya doğru kayan animasyon
    title: 'Çıkış Yap',
    desc: 'Çıkış yapmak istediğinize emin misiniz?',
    dialogBackgroundColor: Colors.blueGrey.shade900,  // Arka plan rengini koyu hale getirdik
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    descTextStyle: const TextStyle(
      color: Colors.white70,
      fontSize: 18,
    ),
    btnCancelOnPress: () {},
    btnCancelText: 'Hayır',
    btnCancelColor: Colors.redAccent,  // İptal buton rengi
    btnOkOnPress: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    },
    btnOkText: 'Evet',
    btnOkColor: Colors.greenAccent,  // Onay buton rengi
    customHeader: Icon(
      Icons.exit_to_app,
      size: 60,
      color: Colors.amberAccent,
    ),
  ).show();
}
