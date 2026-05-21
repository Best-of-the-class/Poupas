import 'package:flutter/material.dart';

import '../widgets/welcome_image.dart';
import '../widgets/welcome_actions.dart';
import '../widgets/welcome_texts.dart';

class WelcomeMobileLayout extends StatelessWidget {
  const WelcomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Expanded(
              child: WelcomeImage(),
            ),
            _BottomSection(),
          ],
        ),
      ),
    );
  }
}

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 40, 25, 40),
      decoration: const BoxDecoration(
        color: Color(0xFF0CC400),
      ),
      child: const Column(
        children: [
          WelcomeTexts(),
          SizedBox(height: 40),
          WelcomeActions(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}