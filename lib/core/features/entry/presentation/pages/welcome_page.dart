import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/widgets/pop_up.dart';
import 'package:pomo/core/widgets/wide_button.dart';
import 'package:pomo/core/theme/app_colors.dart';

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

  Future<bool> _onWillPop(BuildContext context) async {
    PopUp.show(
      context,
      title: "Sair do app",
      subtitle: "Deseja realmente fechar o aplicativo?",
      buttons: [
        WideButton(
          text: "Cancelar",
          onPress: () {
            Navigator.pop(context); // fecha popup
          },
        ),
        WideButton(
          text: "Sair",
          onPress: () {
            SystemNavigator.pop();
          },
          backgroundColor: Colors.transparent,
          textColor: AppColors.error,
          borderColor: AppColors.error,
        ),
      ],
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
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
                  const Text(
                    "Bem-vindo ao Poupas!",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Um jeito divertido de aprender a poupar",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 50),

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
                    borderColor: Color(0xFFE32626),
                    textColor: Color(0xFFE32626),
                    onPress: () {
                      context.push('/signIn');
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