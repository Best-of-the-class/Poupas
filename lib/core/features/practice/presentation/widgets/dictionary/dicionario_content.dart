import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'flashcard/dicionario_flashcard.dart';

class DicionarioContent extends StatelessWidget {
  const DicionarioContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            'Sempre que estiver em dúvida sobre alguma palavra, consulte o dicionário de termos. Toque nos flashcards abaixo e veja o significado.',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textDark,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          const Expanded(
            child: Center(
              child: DicionarioFlashcard(),
            ),
          ),
        ],
      ),
    );
  }
}