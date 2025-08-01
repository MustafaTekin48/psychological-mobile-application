import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/login/login_screen.dart';
import 'package:flutter_application_1/database/database_helper.dart'; // Veritabanı helper'ı
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = await DatabaseHelper().database;

  // ✅ Veritabanına test kullanıcısı ekle
  await db.insert(
    'auth_users',
    {
      'email': 'test@example.com',
      'password_hash': '123456',
      'created_at': DateTime.now().toIso8601String(),
    },
    conflictAlgorithm: ConflictAlgorithm.ignore, // aynı email varsa eklemez
  );

  // ✅ Kullanıcıları terminale yazdır
  final users = await db.query('auth_users');
  for (var user in users) {
    print('✅ Kullanıcı: ${user['email']} - Kayıt: ${user['created_at']}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: LoginScreen(),
    );
  }
}
