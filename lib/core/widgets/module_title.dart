import 'package:flutter/material.dart';
import 'module.dart';
import '../theme/app_colors.dart';

class ModuleTitle extends StatelessWidget {
  final String title;
  final Module theme;

  const ModuleTitle({super.key, required this.title, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
      decoration: ShapeDecoration(
        color: theme.primaryColor,
        shape: const StadiumBorder(),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColors.textLight,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
