import 'package:flutter/material.dart';
import 'pop_up_admin.dart';
import 'wide_button.dart';
import '../theme/app_colors.dart';

class PopUpSuccessAdmin {
  static void show(BuildContext context, String message) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (dialogContext, anim1, anim2) {
        return PopUpAdmin(
          title: message,
          actions: [
            WideButton(
              text: 'Fechar',
              backgroundColor: AppColors.dictionaryIcon1,
              onPress: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
