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

              const Icon(
                Icons.emoji_events_outlined,
                size: 60,
                color: AppColors.highlight,
              ),

              const SizedBox(height: 16),

              Text(
                'Resultado da Lição',
                style: AppTextStyles.title.copyWith(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 20),

              _ResultRow(
                label: 'Acertos',
                value: '$acertos',
                color: AppColors.success,
                icon: Icons.check_circle_outline,
              ),

              const SizedBox(height: 10),

              _ResultRow(
                label: 'Erros',
                value: '$erros',
                color: AppColors.error,
                icon: Icons.cancel_outlined,
              ),

              const SizedBox(height: 10),

              _ResultRow(
                label: 'XP ganho',
                value: '+$xpGanho',
                color: AppColors.highlight,
                icon: Icons.star_outline,
              ),

              const SizedBox(height: 10),

              _ResultRow(
                label: 'Sequência',
                value: ganhouSequencia ? '+1 dia' : '—',
                color: AppColors.primary,
                icon: Icons.local_fire_department_outlined,
              ),
            ],
          ),
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
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              label,
              style: AppTextStyles.body.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Text(
            value,
            style: AppTextStyles.body.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}