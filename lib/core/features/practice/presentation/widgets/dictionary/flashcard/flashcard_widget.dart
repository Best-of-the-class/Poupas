import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class FlashcardWidget extends StatelessWidget {
  final String termo;
  final String significado;
  final Color color;
  final bool isBack;

  const FlashcardWidget.front({
    super.key,
    required this.termo,
    required this.color,
  })  : significado = '',
        isBack = false;

  const FlashcardWidget.back({
    super.key,
    required this.termo,
    required this.significado,
    required this.color,
  }) : isBack = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: isBack ? _buildBack() : _buildFront(),
    );
  }

  Widget _buildFront() {
    return Center(
      child: Text(
        termo,
        textAlign: TextAlign.center,
        style: AppTextStyles.title.copyWith(
          fontSize: 32,
          color: AppColors.textDark,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          termo,
          style: AppTextStyles.title.copyWith(
            fontSize: 24,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Text(
              significado,
              style: AppTextStyles.body.copyWith(
                fontSize: 15,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}