import 'package:flutter/material.dart';

import '../../../../widgets/navigate_top_corner.dart';
import '../widgets/login_form.dart';

class LoginDesktopLayout extends StatelessWidget {
  const LoginDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // largura responsiva do formulário no desktop
    final double formWidth = screenWidth > 1400
        ? 620
        : screenWidth > 1100
            ? 560
            : 500;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // imagem inferior esquerda
            Positioned(
              left: 32,
              bottom: 0,
              child: Image.asset(
                'lib/core/assets/images/poup_bottom.png',
                width: 320,
                fit: BoxFit.contain,
              ),
            ),

            // imagem inferior direita
            Positioned(
              right: 32,
              bottom: 24,
              child: Image.asset(
                'lib/core/assets/images/poupas_assinatura.png',
                width: 180,
                fit: BoxFit.contain,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: NavigateTopCorner(route: 'welcome'),
                  ),

                  Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: formWidth,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: LoginForm(isAdmin: true),
                          ),
                        ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}