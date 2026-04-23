import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class LessonFinalIntroPage extends StatelessWidget {
  final VoidCallback? onNext;

  const LessonFinalIntroPage({
    super.key,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: 'Bora lá!',
      onButtonPressed: onNext ?? () => Navigator.pop(context),

      child: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'lib/core/assets/icons/icon-iniciar-prova-final.png',
                width: 120,
                height: 120,
              ),

              const SizedBox(height: 20),

              Text(
                'Prova Final do Módulo',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(fontSize: 20),
              ),

              const SizedBox(height: 12),

              Text(
                'Essa é sua chance de mostrar tudo o que aprendeu até aqui. '
                'Responda com atenção e tente dar o seu melhor!',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.highlight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Estamos prontos para esse desafio!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.highlight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}