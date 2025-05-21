import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gradution_project/core/theme/theme_cubit.dart';
import 'package:gradution_project/core/utils/App_color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String? label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isEditing,
    this.label,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    required Null Function(dynamic value) onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: TextStyle(
                color: context.watch<ThemeCubit>().state
                    ? Colors.white
                    : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: isEditing,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Concert One',
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: Colors.white)
                  : null,
              filled: true,
              fillColor: AppColor.black,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColor.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColor.white, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColor.red, width: 2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: AppColor.red, width: 2),
              ),
              errorStyle: const TextStyle(color: AppColor.red),
            ),
          ),
        ],
      ),
    );
  }
}
