import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class custom_text_field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint_text;
  final bool obscure_text;
  final TextInputType? keyboard_type;
  final IconData? prefix_icon;
  final Widget? suffix_icon;
  final String? Function(String?)? validator;
  final int? max_lines;
  final int? max_length;
  final bool enabled;

  const custom_text_field({
    super.key,
    required this.controller,
    required this.label,
    this.hint_text,
    this.obscure_text = false,
    this.keyboard_type,
    this.prefix_icon,
    this.suffix_icon,
    this.validator,
    this.max_lines = 1,
    this.max_length,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: app_colors.text_primary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure_text,
          keyboardType: keyboard_type,
          validator: validator,
          maxLines: max_lines,
          maxLength: max_length,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: hint_text,
            prefixIcon: prefix_icon != null ? Icon(prefix_icon) : null,
            suffixIcon: suffix_icon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: app_colors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: app_colors.error),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}
