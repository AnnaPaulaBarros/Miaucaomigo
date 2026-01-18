import 'package:flutter/material.dart';

class PdfInput extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;

  const PdfInput({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBE4AD),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF7A5948), width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(color: Color(0xFF7A5948)),
        ),
      ),
    );
  }
}
