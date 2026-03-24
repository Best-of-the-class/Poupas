import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'heading_text.dart';
import 'wide_button.dart';

class PopUp extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<WideButton> buttons;

  const PopUp({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttons,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF8F1E7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      child:
          Padding(
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
                    Column(
                      children:
                          buttons
                              .expand(
                                (button) => [
                                  button,
                                  const SizedBox(height: 12),
                                ],
                              )
                              .toList()
                            ..removeLast(),
                    ),
                  ],
                ),
              )
              .animate()
              .fade(duration: 200.ms)
              .shake(hz: 4, curve: Curves.easeInOutCubic, duration: 400.ms),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<WideButton> buttons,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return PopUp(title: title, subtitle: subtitle, buttons: buttons);
      },
    );
  }
}
