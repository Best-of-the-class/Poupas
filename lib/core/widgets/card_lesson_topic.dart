import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

enum LessonType {
  conceito,
  questao,
  prova,
}

class LessonTopicConfig {
  final String icon;
  final Color cardColor;
  final Color iconBackground;
  final String label;

  const LessonTopicConfig({
    required this.icon,
    required this.cardColor,
    required this.iconBackground,
    required this.label,
  });
}

const Map<LessonType, LessonTopicConfig> lessonConfigs = {
  LessonType.conceito: LessonTopicConfig(
    icon: 'lib/core/assets/icons/icon-licao-conceito.png',
    cardColor: AppColors.definicaoBg,
    iconBackground: AppColors.definicaoIcon,
    label: 'Conceito',
  ),
  LessonType.questao: LessonTopicConfig(
    icon: 'lib/core/assets/icons/icon-licao-questao.png',
    cardColor: AppColors.questaoBg,
    iconBackground: AppColors.questaoIcon,
    label: 'Questão',
  ),
  LessonType.prova: LessonTopicConfig(
    icon: 'lib/core/assets/icons/icon-licao-prova.png',
    cardColor: AppColors.provaBg,
    iconBackground: AppColors.provaIcon,
    label: 'Prova Final',
  ),
};

class CardLessonTopic extends StatelessWidget {
  final int ordem;
  final String titulo;
  final LessonType type;

  const CardLessonTopic({
    super.key,
    required this.ordem,
    required this.titulo,
    required this.type,
  });

  LessonTopicConfig get config =>
      lessonConfigs[type]!;

  String get subtitle {
    switch (type) {
      case LessonType.conceito:
        return titulo; 
      case LessonType.questao:
        return 'Questão $ordem';
      case LessonType.prova:
        return 'Prova Final';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: config.iconBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Image.asset(
                config.icon,
                width: 48,
                height: 48,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lição $ordem | $titulo',
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    color: const Color(0xFF363636),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF363636),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}