import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class IconInput extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String)? onChanged;

  const IconInput({
    super.key,
    required this.hint,
    required this.icon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      cursorColor: AppColors.dictionaryPrimary,
      style: const TextStyle(fontSize: 18, color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Icon(icon, color: Colors.grey, size: 28),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            color: AppColors.dictionaryPrimary,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}
