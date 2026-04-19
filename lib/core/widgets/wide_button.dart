import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class WideButton extends StatelessWidget {
  final String text;
  final VoidCallback onPress;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final Widget? icon;

  const WideButton({
    super.key,
    required this.text,
    required this.onPress,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.textLight;

    final label = Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.body.copyWith(
        color: effectiveTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    final content = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon!,
              const SizedBox(width: 8),
              Flexible(child: label),
            ],
          )
        : label;

    final button = OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        backgroundColor: effectiveBgColor,
        shape: const StadiumBorder(),
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: content,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide =
            constraints.hasBoundedWidth && constraints.maxWidth > 300;

        if (isWide) {
          return SizedBox(
            width: constraints.maxWidth,
            height: 56,
            child: button,
          );
        }

        return IntrinsicWidth(child: SizedBox(height: 56, child: button));
      },
    );
  }
}
