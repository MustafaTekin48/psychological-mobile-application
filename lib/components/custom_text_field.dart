import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/text_field_container.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isConfirmPassword;
  final IconData icon;
  // ikon kısmı eklenecek

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isConfirmPassword = false,
    ValueChanged<String>? onChanged,
    required bool obscureText, 
    required this.icon,  
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword, // Şifre alanı için gizli metin
        decoration: InputDecoration(
          filled: true,
          labelText: hintText,
          icon: Icon(icon, color: Color(0xFF3F3D56)),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            gapPadding: 1.0,
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white),
          ),
          fillColor: Colors.white,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (hintText.contains("Kullanıcı Adı")) {
              return "Lütfen kullanıcı adını giriniz";
            } else if (hintText.contains("Şifre")) {
              return "Lütfen şifrenizi giriniz";
            }
          } else if (value.length < 5 && isPassword) {
            return "Lütfen en az 5 karakter giriniz!";
          } 
          return null;
        },
      ),
    );
  }
}
