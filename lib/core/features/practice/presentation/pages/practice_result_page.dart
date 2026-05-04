import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class PracticeResultPage extends StatelessWidget {
  final int acertos;
  final int erros;

  const PracticeResultPage({
    super.key,
    required this.acertos,
    required this.erros,
  });

  bool get success => erros == 0;
  int get xp => acertos * 100;

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: 'Continuar',
      onButtonPressed: () {
        Navigator.popUntil(context, (route) => route.isFirst);
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [

                Container(
                  margin: const EdgeInsets.only(top: 130),
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 30),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: success
                              ? AppColors.resultSuccessBg
                              : AppColors.resultErrorBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          success ? Icons.check : Icons.close,
                          size: 48,
                          color: success
                              ? AppColors.resultSuccessIcon
                              : AppColors.resultErrorIcon,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Text(
                        success ? 'Mandou bem!' : 'Não foi dessa vez',
                        style: AppTextStyles.title.copyWith(
                          fontSize: 18,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        success
                            ? 'Você acertou o exercício!'
                            : 'Esse exercício ainda estará disponível para revisão, continue praticando!',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _ResultRow(
                        label: 'Pontuação (XP)',
                        value: '+$xp',
                        color: const Color(0xFFFBD564),
                        icon: Icons.star_outline,
                      ),
                    ],
                  ),
                ),

                Image.asset(
                  'lib/core/assets/images/poup-happy.png',
                  width: 150,
                  height: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.textDark,
            size: 24,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: AppColors.textDark,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}