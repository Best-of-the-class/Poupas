import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/responsive/size_extensions.dart';

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
//    final isMobile = MediaQuery.of(context).size.width < 600;
    final double height = context.isMobile ? 56 : 46;

    final effectiveBgColor = backgroundColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.textLight;

    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.body.copyWith(
        color: effectiveTextColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );

    final child = icon != null
        ? Row(
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
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: child,
    );

    return FractionallySizedBox(
      widthFactor: context.isMobile ? 1.0 : 0.80, // desktop menor que input
      child: SizedBox(
        height: height,
        child: button,
      ),
    );
  }
}