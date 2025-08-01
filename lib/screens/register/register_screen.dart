import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/register/user_details_screen.dart';
import '../../components/rounded_button.dart';
import '../../components/warning_dialog.dart';
import '../../constant/app_text_style.dart';
import '../login/login_screen.dart';
import 'kvkk_text.dart';
import 'package:flutter_application_1/database/database_helper.dart'; // EKLENDİ

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isKVKKAccepted = false;

  void _showKVKKDialog(BuildContext context) async {
    bool? result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return KVKKScreen();
      },
    );

    if (result != null) {
      setState(() {
        _isKVKKAccepted = result;
      });
    }
  }

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!_isKVKKAccepted) {
        WarningDialog.show(context);
        return;
      }

      final db = await DatabaseHelper().database;
      final email = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      // Aynı kullanıcı var mı kontrol et
      final existing = await db.query(
        'auth_users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existing.isNotEmpty) {
        // Aynı email zaten kayıtlı
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Kayıt Hatası"),
            content: const Text("Bu e-posta adresi zaten kayıtlı."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Tamam"),
              ),
            ],
          ),
        );
        return;
      }

      // Yeni kullanıcıyı ekle
      await db.insert(
        'auth_users',
        {
          'email': email,
          'password_hash': password,
          'created_at': DateTime.now().toIso8601String(),
        },
      );

      print('✅ Yeni kullanıcı eklendi: $email');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserDetailsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "HOŞ GELDİNİZ",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: "Kullanıcı Adını Belirleyiniz",
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          prefixIcon: Icon(Icons.person, color: Colors.grey.shade700),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lütfen kullanıcı adını giriniz';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifrenizi Belirleyiniz",
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey.shade700),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lütfen şifrenizi giriniz';
                          } else if (value.length < 6) {
                            return 'Şifre en az 6 karakter olmalıdır';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Şifrenizi Tekrar Giriniz",
                          labelStyle: TextStyle(color: Colors.grey.shade700),
                          prefixIcon: Icon(Icons.lock, color: Colors.grey.shade700),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.deepPurple, width: 1.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Lütfen şifrenizi tekrar giriniz';
                          } else if (value != _passwordController.text) {
                            return 'Şifreler eşleşmiyor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            value: _isKVKKAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isKVKKAccepted = value ?? false;
                              });
                              if (value == true) {
                                _showKVKKDialog(context);
                              }
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _showKVKKDialog(context),
                              child: const Text(
                                'KVKK Sözleşmesini Okudum ve Kabul Ediyorum',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      RoundedButton(
                        text: "Kayıt Ol",
                        color: Colors.deepPurple,
                        textColor: Colors.white,
                        press: () => _register(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hesabınız var mı?",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Giriş Yap",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
