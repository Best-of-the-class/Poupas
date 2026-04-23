import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class LessonConceptPage extends StatelessWidget {
  final int ordem;
  final String titulo;
  final String texto;

  final VoidCallback? onNext;

  const LessonConceptPage({
    super.key,
    this.ordem = 1,
    this.titulo = 'Lição',
    this.texto = 'Texto temporário da lição...',
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: 'Próximo',

      onButtonPressed: onNext ?? () => Navigator.pop(context),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLessonTopic(
            ordem: ordem,
            titulo: titulo,
            type: LessonType.conceito,
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                texto,
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}