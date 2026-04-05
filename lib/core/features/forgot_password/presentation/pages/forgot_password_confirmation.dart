import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/widgets/custom_positioned_image.dart';
import '../../../sign_in/presentati../../../../widgets/wide_button.dart';

class ForgotPasswordConfirmation extends StatelessWidget {
  const ForgotPasswordConfirmation({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPositionedImage(
      imageSize: 220,
      imagePath:
          'lib/core/features/forgot_password/presentation/assets/images/poup_check.png',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 180),
            const Text(
              'Sua nova senha foi adicionada com sucesso. Por questões de segurança, você deverá fazer login novamente.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4A4A4A),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 48),
            WideButton(
              text: 'Ir para Login',
              onPress: () => context.goNamed('login'),
            ),
          ],
        ),
      ),
    );
  }
}
