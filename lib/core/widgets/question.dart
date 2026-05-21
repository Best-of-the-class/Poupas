import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class Question extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final Color? themeColor;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const Question({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    this.themeColor,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = themeColor ?? AppColors.provaIcon;

    return Container(
      height: 90,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: 0.5),
        border: Border.all(color: activeColor, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: activeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textLight,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        subtitle,
                        style: AppTextStyles.body.copyWith(
                          color: activeColor.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: (_) => onToggle?.call(),
                          activeColor: activeColor,
                          checkColor: AppColors.textLight,
                          side: BorderSide(color: activeColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (onDelete != null)
            GestureDetector(
              onTap: onDelete,
              child: Container(
                width: 60,
                height: double.infinity,
                color: activeColor,
                child: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textLight,
                  size: 30,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
