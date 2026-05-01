import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/wide_button.dart';

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WideButton(
          text: 'Faça login',
          onPress: () {
            context.push('/login');
          },
        ),
    
        const SizedBox(height: 12),

        WideButton(
          text: 'Cadastrar',
          backgroundColor: Colors.white,
          borderColor: const Color(0xFFE32626),
          textColor: const Color(0xFFE32626),
          onPress: () {
            context.push('/signIn');
          },
        ),
      ],
    );
  }
}