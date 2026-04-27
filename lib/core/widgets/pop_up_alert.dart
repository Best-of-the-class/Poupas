import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'heading_text.dart';
import 'wide_button.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/responsive/size_extensions.dart';

class AlertPopUp extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onPressed;

  const AlertPopUp({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = 'OK',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
//    final isMobile = screenWidth < 600;
    final dialogWidth = context.isMobile ? screenWidth * 0.88 : screenWidth * 0.4;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: SizedBox(
        width: dialogWidth,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),

              HeadingText(
                title: title,
                subtitle: subtitle,
                alignment: CrossAxisAlignment.center,
              ),

              const SizedBox(height: 32),

              WideButton(
                text: buttonText,
                onPress: onPressed,
              ),
            ],
          ),
        )
            .animate()
            .fade(duration: 200.ms)
            .scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: 200.ms,
              curve: Curves.easeOut,
            )
            .shake(
              hz: 3,
              curve: Curves.easeInOutCubic,
              duration: 300.ms,
            ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    String buttonText = 'OK, entendi!',
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return AlertPopUp(
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onPressed: () => Navigator.pop(context),
        );
      },
    );
  }
}