import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/lesson_layout.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';
import 'package:pomo/core/features/practice/presentation/pages/practice_result_page.dart';
import 'package:pomo/core/widgets/pop_up_alert.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/theme/app_colors.dart';

String optionLabelForIndex(int index) {
  const labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

  if (index >= 0 && index < labels.length) {
    return labels[index];
  }

  return (index + 1).toString();
}

class LessonQuestionPage extends StatefulWidget {
  final int ordem;
  final String titulo;
  final String pergunta;

  final List<String> alternativas;
  final List<int> alternativaIds;
  final int? indiceCorreto;
  final bool isFinalExam;
  final bool isPractice;
  final int vidasAtuais;
  final int vidasTotal;
  final void Function(bool? acertou, int? alternativaEscolhidaId)? onNext;

  const LessonQuestionPage({
    super.key,
    this.ordem = 1,
    this.titulo = 'Lição',
    this.pergunta = 'Pergunta temporária da questão...',
    required this.alternativas,
    this.alternativaIds = const [],
    this.indiceCorreto,
    this.isFinalExam = false,
    this.isPractice = false,
    this.vidasAtuais = 5,
    this.vidasTotal = 5,
    this.onNext,
  });

  @override
  State<LessonQuestionPage> createState() => _LessonQuestionPageState();
}

class _LessonQuestionPageState extends State<LessonQuestionPage> {
  int? selectedIndex;
  bool answered = false;

  bool get _canRevealAnswer =>
      widget.indiceCorreto != null && widget.indiceCorreto! >= 0;

  int? get _selectedAlternativeId =>
      selectedIndex != null && selectedIndex! < widget.alternativaIds.length
      ? widget.alternativaIds[selectedIndex!]
      : null;

  void _handleButton() {
    if (selectedIndex == null) {
      _showSelectOptionAlert();
      return;
    }

    if (!_canRevealAnswer && !widget.isPractice) {
      if (widget.onNext != null) {
        widget.onNext!(null, _selectedAlternativeId);
      } else {
        Navigator.pop(context);
      }
      return;
    }

    if (!answered) {
      setState(() {
        answered = true;
      });
      return;
    }

    final acertou = selectedIndex == widget.indiceCorreto;

    if (widget.isPractice) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PracticeResultPage(
            acertos: acertou ? 1 : 0,
            erros: acertou ? 0 : 1,
          ),
        ),
      );
      return;
    }

    if (widget.onNext != null) {
      widget.onNext!(acertou, _selectedAlternativeId);
    } else {
      Navigator.pop(context);
    }
  }

  void _showSelectOptionAlert() {
    AlertPopUp.show(
      context,
      title: 'Você esqueceu, né?',
      subtitle: 'Selecione uma alternativa antes de responder.',
    );
  }

  String get buttonText {
    if (!_canRevealAnswer && !widget.isPractice) return 'Próximo';
    if (!answered) return 'Responder';
    return widget.isPractice ? 'Finalizar' : 'Próximo';
  }

  @override
  Widget build(BuildContext context) {
    return LessonLayout(
      vidasAtuais: widget.isPractice ? 0 : widget.vidasAtuais,
      vidasTotal: widget.isPractice ? 0 : widget.vidasTotal,
      buttonText: buttonText,
      onButtonPressed: _handleButton,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLessonTopic(
            ordem: widget.ordem,
            titulo: widget.titulo,
            type: widget.isFinalExam ? LessonType.prova : LessonType.questao,
          ),

          const SizedBox(height: 20),

          Text(
            widget.pergunta,
            style: AppTextStyles.body.copyWith(fontSize: 16, height: 1.5),
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
    final isCorrect = _canRevealAnswer && index == widget.indiceCorreto;

    Color backgroundColor = AppColors.background;
    Color borderColor = AppColors.textDark;

    if (!answered) {
      if (isSelected) {
        backgroundColor = AppColors.surface;
        borderColor = AppColors.definicaoIcon;
      }
    } else if (_canRevealAnswer) {
      if (isCorrect) {
        backgroundColor = AppColors.success;
        borderColor = AppColors.success;
      } else if (isSelected) {
        backgroundColor = AppColors.wrong;
        borderColor = AppColors.wrong;
      } else {
        backgroundColor = AppColors.background;
        borderColor = AppColors.textDark;
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
                optionLabelForIndex(index),
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
                style: AppTextStyles.body.copyWith(color: AppColors.textDark),
              ),
            ),

            if (answered && _canRevealAnswer) ...[
              if (isCorrect && isSelected)
                const Icon(
                  Icons.check,
                  color: AppColors.correctCheck,
                  size: 40,
                ),

              if (!isCorrect && isSelected)
                const Icon(Icons.close, color: AppColors.error, size: 40),
            ],
          ],
        ),
      ),
    );
  }
}
