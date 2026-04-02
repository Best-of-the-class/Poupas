import 'package:flutter/material.dart';
import '../../../sign_in/presentation/widgets/background.dart';
import '../../../sign_in/presentation/widgets/wide_button.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeContent(),
    );
  }
}

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({super.key});

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end, // Alinha tudo pra baixo
        children: [

          /// IMAGEM
          Image.asset(
            'lib/core/features/entry/presentation/assets/image/Poup.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          /// CONTAINER
          Container(
            width: double.infinity,
            height: 350,
            padding: const EdgeInsets.only(
              top: 0, 
              left: 24,
              right: 24,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF0CC400),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Bem-vindo ao Poupas!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Text(
                  "Um jeito divertido de aprender a poupar",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50),
                WideButton(
                  text: 'Faça login',
                  onPress: () {
                    context.go('/login');
                  },
                ),
                SizedBox(height: 12),
                WideButton(
                  text: 'Cadastrar',
                  backgroundColor: Colors.white,
                  borderColor: Color(0xFFE32626),
                  textColor: Color(0xFFE32626),
                  onPress: () {
                    context.go('/signIn');
                  },
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