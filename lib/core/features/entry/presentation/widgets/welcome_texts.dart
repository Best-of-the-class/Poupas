import 'package:flutter/material.dart';

class WelcomeTexts extends StatelessWidget {
  const WelcomeTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Bem-vindo ao Poupas!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Um jeito divertido de aprender a poupar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}