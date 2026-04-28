import 'package:flutter/material.dart';

import '../widgets/welcome_image.dart';
import '../widgets/welcome_actions.dart';
import '../widgets/welcome_texts.dart';

class WelcomeDesktopLayout extends StatelessWidget {
  const WelcomeDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Expanded(
            flex: 6,
            child: WelcomeImage(),
          ),

          Expanded(
            flex: 5,
            child: Container(
              color: const Color(0xFF0CC400),
              child: const Center(
                child: SizedBox(
                  width: 460,
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WelcomeTexts(),
                        SizedBox(height: 48),
                        WelcomeActions(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}