import 'package:flutter/material.dart';
import 'module.dart';

class CustomIconButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final IconButtonPosition iconPosition;
  final VoidCallback onTap;
  final Module theme;

  const CustomIconButton({
    super.key,
    required this.title,
    this.icon,
    this.iconPosition = IconButtonPosition.left,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: const StadiumBorder(),
        elevation: 0,
        minimumSize: const Size(0, 48),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && iconPosition == IconButtonPosition.left) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (icon != null && iconPosition == IconButtonPosition.right) ...[
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white, size: 20),
          ],
        ],
      ),
    );
  }
}
