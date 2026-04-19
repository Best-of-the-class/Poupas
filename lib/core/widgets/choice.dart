import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class Choice extends StatelessWidget {
  final String letter;
  final TextEditingController controller;
  final bool isSelected;
  final bool isCorrect;
  final Color themeColor;
  final VoidCallback onSelected;

  const Choice({
    super.key,
    required this.letter,
    required this.controller,
    required this.isSelected,
    required this.isCorrect,
    required this.themeColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: isCorrect ? themeColor : AppColors.border.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.perfilAvatar,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: AppTextStyles.title.copyWith(
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: themeColor,
              decoration: InputDecoration(
                hintText: 'Alternativa...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintStyle: AppTextStyles.body.copyWith(color: Colors.grey),
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.transparent,
              ),
              style: AppTextStyles.body,
            ),
          ),
          GestureDetector(
            onTap: onSelected,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected
                      ? AppColors.success
                      : AppColors.border.withOpacity(0.5),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
                color: isSelected ? AppColors.success : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.textLight,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
