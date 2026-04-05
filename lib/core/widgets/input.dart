import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Input extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon; 
  final List<TextInputFormatter>? inputFormatters; 
  final Function(String)? onChanged;

  const Input({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      cursorColor: const Color(0xFFE32626),
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        
        suffixIcon: suffixIcon != null 
            ? Padding(
                padding: const EdgeInsets.only(right: 12),
                child: suffixIcon,
              ) 
            : null,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Color(0xFFE32626), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Color(0xFFE32626), width: 2.0),
        ),
      ),
    );
  }
}