import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final Widget? icon;

  const WideButton({
    super.key,
    required this.text,
    required this.onPress,
    this.backgroundColor = const Color(0xFFE32626),
    this.textColor = Colors.white,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56, 
      child: OutlinedButton(
        onPressed: onPress,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: const StadiumBorder(), 
          side: borderColor != null 
              ? BorderSide(color: borderColor!) 
              : BorderSide.none,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}