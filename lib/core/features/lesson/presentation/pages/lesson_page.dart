import 'package:flutter/material.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_concept_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_question_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_result_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_final_intro_page.dart';

class LessonPage extends StatefulWidget {
  final Map<String, dynamic> licao;
  final List<Map<String, dynamic>> atividades;

  const LessonPage({
    super.key,
    required this.licao,
    required this.atividades,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int stepIndex = 0;

  int acertos = 0;
  int erros = 0;

  bool get hasConcept =>
      widget.licao['texto_conceito'] != null &&
      widget.licao['texto_conceito'].toString().isNotEmpty;

  bool get isFinalExam =>
      widget.atividades.any((a) => a['prova_final'] == true);

  void nextStep({bool acertou = false}) {
    if (acertou) {
      acertos++;
    } else if (stepIndex != 0) {
      erros++;
    }

    setState(() {
      stepIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget currentPage;

    if (hasConcept && !isFinalExam && stepIndex == 0) {
      currentPage = LessonConceptPage(
        key: const ValueKey('concept'),
        ordem: widget.licao['ordem'] ?? 1,
        titulo: widget.licao['titulo'] ?? '',
        texto: widget.licao['texto_conceito'] ?? '',
        onNext: () => nextStep(),
      );
    }

    else if (isFinalExam && stepIndex == 0) {
      currentPage = LessonFinalIntroPage(
        key: const ValueKey('intro'),
        onNext: () => nextStep(),
      );
    }

    else {
      final questionIndex = hasConcept && !isFinalExam
          ? stepIndex - 1
          : stepIndex;

      if (questionIndex < widget.atividades.length) {
        final atividade = widget.atividades[questionIndex];

        currentPage = LessonQuestionPage(
          key: ValueKey('question_$questionIndex'),
          ordem: widget.licao['ordem'],
          titulo: widget.licao['titulo'],
          pergunta: atividade['enunciado'],
          isFinalExam: atividade['prova_final'] ?? false,
          alternativas: atividade['alternativas'] ?? [
            'Alternativa A',
            'Alternativa B',
            'Alternativa C',
          ],
          indiceCorreto: atividade['indiceCorreto'] ?? 1,
          onNext: (acertou) => nextStep(acertou: acertou),
        );
      }

      else {
        currentPage = LessonResultPage(
          key: const ValueKey('result'),
          acertos: acertos,
          erros: erros,
          xpBase: widget.licao['recompensa_xp'],
          ganhouSequencia: true,
        );
      }
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),

transitionBuilder: (child, animation) {
  final isResult = child.key == const ValueKey('result');

    if (isResult) {
        return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
            scale: Tween<double>(
            begin: 0.85,
            end: 1.0,
            ).animate(
            CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
            ),
            ),
            child: child,
        ),
        );
    }

    return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
        scale: Tween<double>(
            begin: 0.97,
            end: 1.0,
        ).animate(
            CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
            ),
        ),
        child: child,
        ),
    );
    },

      child: currentPage,
    );
  }
}