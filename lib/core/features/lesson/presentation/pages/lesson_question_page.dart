import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class LessonQuestionPage extends StatelessWidget {
  final int ordem;
  final String titulo;
  final String pergunta;

  const LessonQuestionPage({
    super.key,
    this.ordem = 1,
    this.titulo = 'Lição',
    this.pergunta = 'Pergunta temporária da questão...',
  });

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: 'Responder',
      onButtonPressed: () {
        Navigator.pop(context);
      },

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLessonTopic(
            ordem: ordem,
            titulo: titulo,
            type: LessonType.questao,
          ),

          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                pergunta,
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