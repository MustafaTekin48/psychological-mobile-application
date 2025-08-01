import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/text_field_container.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String>? onChange;
  final bool isPassword;

  const RoundedInputField({
    super.key,
    required this.hintText,
    required this.icon,
    this.onChange, 
    required this.isPassword, 
    required TextEditingController controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      child: TextField(
        onChanged: onChange,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            icon,
            color: const Color(0xFF3F3D56),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            gapPadding: 1.0,
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          fillColor: Colors.grey.shade200,
        ),
      ),
    );
  }
}
