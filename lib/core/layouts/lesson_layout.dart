import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class LessonLayout extends StatelessWidget {
  final Widget child;
  final int vidasAtuais;
  final int vidasTotal;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isButtonDisabled;

  const LessonLayout({
    super.key,
    required this.child,
    required this.vidasAtuais,
    required this.vidasTotal,
    required this.buttonText,
    required this.onButtonPressed,
    this.isButtonDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 40),
                    onPressed: () => Navigator.pop(context),
                  ),

                  // indicador de vidas
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 30
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$vidasAtuais/$vidasTotal',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // conteudo da aula
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),

            // botao de açao
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isButtonDisabled ? null : onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}