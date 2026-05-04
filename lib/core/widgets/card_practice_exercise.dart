import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_question_page.dart';

class CardPracticeExercise extends StatelessWidget {
  final int ordem;
  final String titulo;
  final LessonType type;
  final bool isOpen;
  final VoidCallback onTap;

  final String pergunta;
  final List<String> alternativas;
  final int indiceCorreto;
  final bool isFinalExam;

  const CardPracticeExercise({
    super.key,
    required this.ordem,
    required this.titulo,
    required this.type,
    required this.isOpen,
    required this.onTap,
    required this.pergunta,
    required this.alternativas,
    required this.indiceCorreto,
    this.isFinalExam = false,
  });

  LessonTopicConfig get config => lessonConfigs[type]!;

  String get subtitle {
    switch (type) {
      case LessonType.questao:
        return 'Questão $ordem';
      case LessonType.prova:
        return 'Prova Final';
      default:
        return '';
    }
  }

    @override
    Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4),
            ),
            ],
        ),

        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

                Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: config.cardColor,

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
                                color: AppColors.textDark,
                            ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                            subtitle,
                            style: AppTextStyles.body.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textDark,
                            ),
                            ),
                        ],
                        ),
                    ),
                    ],
                ),
                ),

                AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: isOpen
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,

                firstChild: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,

                    child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (_) => LessonQuestionPage(
                                ordem: ordem,
                                titulo: titulo,
                                pergunta: pergunta,
                                alternativas: alternativas,
                                indiceCorreto: indiceCorreto,
                                isFinalExam: isFinalExam,
                                isPractice: true,
                                onNext: (acertou) {
                                Navigator.pop(context);

                                if (!acertou) {

                                }
                                },
                            ),
                            ),
                        );
                        },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        ),
                    ),
                    child: Text(
                        'Iniciar exercício',
                        style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                    ),
                ),

                secondChild: const SizedBox.shrink(),
                ),
            ],
            ),
        ),
        ),
    );
    }
}