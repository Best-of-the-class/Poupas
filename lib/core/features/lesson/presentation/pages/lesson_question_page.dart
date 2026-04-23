import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';
import 'package:pomo/core/widgets/pop_up_alert.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/theme/app_colors.dart';

class LessonQuestionPage extends StatefulWidget {
  final int ordem;
  final String titulo;
  final String pergunta;

  final List<String> alternativas;
  final int indiceCorreto;
  final bool isFinalExam;
  final Function(bool acertou)? onNext;

  const LessonQuestionPage({
    super.key,
    this.ordem = 1,
    this.titulo = 'Lição',
    this.pergunta = 'Pergunta temporária da questão...',
    required this.alternativas,
    required this.indiceCorreto,
    this.isFinalExam = false,
    this.onNext,
  });

  @override
  State<LessonQuestionPage> createState() => _LessonQuestionPageState();
}

class _LessonQuestionPageState extends State<LessonQuestionPage> {
  int? selectedIndex;
  bool answered = false;

  void _handleButton() {
    if (!answered) {
      if (selectedIndex == null) {
        _showSelectOptionAlert(); // 👈 NOVO
        return;
      }

      setState(() {
        answered = true;
      });
    } else {
      final acertou = selectedIndex == widget.indiceCorreto;

      if (widget.onNext != null) {
        widget.onNext!(acertou);
      } else {
        Navigator.pop(context);
      }
    }
  }

  void _showSelectOptionAlert() {
    AlertPopUp.show(
      context,
      title: 'Você esqueceu, né?',
      subtitle: 'Selecione uma alternativa antes de responder.',
    );
  }

  String get buttonText => answered ? 'Próximo' : 'Responder';

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: 5,
      vidasTotal: 5,
      buttonText: buttonText,
      onButtonPressed: _handleButton,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLessonTopic(
            ordem: widget.ordem,
            titulo: widget.titulo,
            type: widget.isFinalExam
                ? LessonType.prova
                : LessonType.questao,
          ),

          const SizedBox(height: 20),

          Text(
            widget.pergunta,
            style: AppTextStyles.body.copyWith(
              fontSize: 16,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 20),

          ...List.generate(widget.alternativas.length, (index) {
            return _buildOption(index);
          }),
        ],
      ),
    );
  }

  Widget _buildOption(int index) {
    final isSelected = selectedIndex == index;
    final isCorrect = index == widget.indiceCorreto;

    Color backgroundColor = AppColors.background;
    Color borderColor = AppColors.textDark;

    if (!answered) {
      if (isSelected) {
        backgroundColor = AppColors.surface;
        borderColor = AppColors.definicaoIcon;
      }
    } else {
      if (isCorrect) {
        backgroundColor = AppColors.success; 
      } else {
        backgroundColor = AppColors.wrong;  
      }
    }

    return GestureDetector(
      onTap: answered
          ? null
          : () {
              setState(() {
                selectedIndex = index;
              });
            },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.definicaoBg,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                ['A', 'B', 'C'][index],
                style: AppTextStyles.body.copyWith(
                  fontSize: 20,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                widget.alternativas[index],
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textDark,
                ),
              ),
            ),

            if (answered && isCorrect)
              const Icon(
                Icons.check,
                color: AppColors.correctCheck,
                size: 40,
              ),
          ],
        ),
      ),
    );
  }
}