import 'package:flutter/material.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: Align(
        alignment: Alignment.bottomCenter,
        child: Image.asset(
          'lib/core/features/entry/presentation/assets/image/Poup.png',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}