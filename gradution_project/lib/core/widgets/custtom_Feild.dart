import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../theme/theme_cubit.dart';
import '../utils/App_color.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final String? label;
  final TextEditingController controller;
  final bool isEditing;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.isEditing,
    this.label,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText ?? false;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Text(
              widget.label!,
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
            obscureText: _obscureText,
            controller: widget.controller,
            enabled: widget.isEditing,
            keyboardType: widget.keyboardType,
            style: const TextStyle(color: Colors.white),
            validator: widget.validator,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.white70,
                fontFamily: 'Concert One',
              ),
              suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                      ),
                      onPressed: _toggleVisibility,
                    )
                  : widget.suffixIcon,
              prefixIcon: widget.prefixIcon != null
                  ? Icon(widget.prefixIcon, color: Colors.white)
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
