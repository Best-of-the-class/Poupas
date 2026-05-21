import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class ShortcutCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String imagePath;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const ShortcutCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.imagePath,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // título
              Text(
                titulo.toUpperCase(),
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                  fontSize: 18,
                  color: AppColors.title,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 118,
                height: 118,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                descricao,
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}