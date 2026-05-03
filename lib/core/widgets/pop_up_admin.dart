import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PopUpAdmin extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const PopUpAdmin({super.key, required this.title, required this.actions});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: AppColors.dictionaryPrimary,
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                for (int i = 0; i < actions.length; i++) ...[
                  Expanded(child: actions[i]),
                  if (i < actions.length - 1) const SizedBox(width: 16),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<Widget> actions,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return PopUpAdmin(title: title, actions: actions);
      },
    );
  }
}
