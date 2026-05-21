import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class HeadingText extends StatelessWidget {
  final String title;
  final String subtitle;
  final CrossAxisAlignment alignment;

  const HeadingText({
    super.key,
    required this.title,
    required this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.title.copyWith(fontSize: 22, letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textDark.withValues(alpha: 0.9),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
