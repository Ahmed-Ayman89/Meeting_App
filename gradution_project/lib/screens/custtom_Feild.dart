import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isEditing;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          enabled: isEditing,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintStyle:
                TextStyle(color: Colors.white, fontFamily: 'Concert One'),
            hintText: hintText,
            filled: true,
            fillColor: const Color(0xFF30C3D4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(21),
            ),
          ),
        ),
      ],
    );
  }
}
