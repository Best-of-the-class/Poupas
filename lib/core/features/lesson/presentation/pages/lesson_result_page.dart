import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class LessonResultPage extends StatelessWidget {
  final int acertos;
  final int erros;
  final int xpGanho;
  final bool ganhouSequencia;

  const LessonResultPage({
    super.key,
    this.acertos = 3,
    this.erros = 1,
    this.xpGanho = 120,
    this.ganhouSequencia = true,
  });

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: 'Continuar',
      onButtonPressed: () {
        Navigator.pop(context);
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
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFA2CA8B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 48,
                                color: Color(0xFF117302),
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'UAU, PARABÉNS!',
                                    style: AppTextStyles.title.copyWith(
                                      fontSize: 18,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Mais um desafio concluído',
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        _ResultRow(
                          label: 'Acertos',
                          value: '$acertos',
                          color: const Color(0xFFA2CA8B),
                          icon: Icons.check_circle_outline,
                        ),

                        const SizedBox(height: 10),

                        _ResultRow(
                          label: 'Erros',
                          value: '$erros',
                          color: const Color(0xFFFBA29B),
                          icon: Icons.cancel_outlined,
                        ),

                        const SizedBox(height: 10),

                        _ResultRow(
                          label: 'Pontuação (XP)',
                          value: '+$xpGanho',
                          color: const Color(0xFFFBD564),
                          icon: Icons.star_outline,
                        ),

                        const SizedBox(height: 10),

                        _ResultRow(
                          label: 'Sequência',
                          value: ganhouSequencia ? '+1 dia' : '—',
                          color: const Color(0xFFFFAA5A),
                          icon: Icons.local_fire_department_outlined,
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
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}