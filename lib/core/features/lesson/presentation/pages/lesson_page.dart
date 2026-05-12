import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_concept_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_question_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_result_page.dart';
import 'package:pomo/core/features/admin/presentation/bloc/lesson_bloc.dart'; 

class LessonPage extends StatefulWidget {
  final Map<String, dynamic> licao;
  final List<dynamic>? atividades;

  const LessonPage({
    super.key,
    required this.licao,
    this.atividades,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  int stepIndex = 0;
  int acertos = 0;
  int erros = 0;

  @override
  void initState() {
    super.initState();
    final titulo = widget.licao['titulo'] ?? widget.licao['tituloLicao'];
    if (titulo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LessonBloc>().add(LoadLessonDetails(titulo));
      });
    }
  }

  void nextStep({bool acertou = false}) {
    if (acertou) {
      acertos++;
    } else if (stepIndex != 0) {
      erros++;
    }
    setState(() => stepIndex++);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        if (state.isLoading || state.lessonDetails == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5EEDA),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE32626)),
            ),
          );
        }

        final details = state.lessonDetails!;
        
        final String textoConceito = details['textoConceito'] ?? details['TextoConceito'] ?? details['texto_conceito'] ?? '';
        final String tituloLicao = details['tituloLicao'] ?? details['TituloLicao'] ?? widget.licao['titulo'] ?? 'Lição';
        final int xpLicao = details['recompensaXp'] ?? details['RecompensaXp'] ?? details['recompensa_xp'] ?? 50;
        final int ordemLicao = details['ordem'] ?? details['Ordem'] ?? widget.licao['ordem'] ?? 1;
        
        final List<dynamic> atividades = details['questoes'] ?? details['Questoes'] ?? [];

        final bool hasConcept = textoConceito.trim().isNotEmpty;
        final bool isFinalExam = false; 

        Widget currentPage;

        if (hasConcept && !isFinalExam && stepIndex == 0) {
          currentPage = LessonConceptPage(
            key: const ValueKey('concept'),
            ordem: ordemLicao,
            titulo: tituloLicao,
            texto: textoConceito,
            onNext: () => nextStep(),
          );
        } 
        else {
          final questionIndex = hasConcept && !isFinalExam ? stepIndex - 1 : stepIndex;

          if (questionIndex < atividades.length) {
            final atividade = atividades[questionIndex] as Map<String, dynamic>;
            
            final String enunciado = atividade['enunciado'] ?? atividade['Enunciado'] ?? '';
            final List<String> alternativas = List<String>.from(atividade['alternativas'] ?? atividade['Alternativas'] ?? []);
            final int indiceCorreto = atividade['indiceCorreta'] ?? atividade['IndiceCorreta'] ?? 0;

            currentPage = LessonQuestionPage(
              key: ValueKey('question_$questionIndex'),
              ordem: questionIndex + 1,
              titulo: 'Questão',        
              pergunta: enunciado,
              isFinalExam: isFinalExam,
              alternativas: alternativas,
              indiceCorreto: indiceCorreto,
              onNext: (acertou) => nextStep(acertou: acertou),
            );
          } else {
            currentPage = LessonResultPage(
              key: const ValueKey('result'),
              acertos: acertos,
              erros: erros,
              xpBase: xpLicao,
              ganhouSequencia: erros == 0, 
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
                  scale: Tween<double>(begin: 0.85, end: 1.0).animate(
                    CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                  ),
                  child: child,
                ),
              );
            }
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.97, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.easeOut),
                ),
                child: child,
              ),
            );
          },
          child: currentPage,
        );
      },
    );
  }
}