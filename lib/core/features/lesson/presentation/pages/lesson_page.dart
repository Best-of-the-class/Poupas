import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_concept_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_question_page.dart';
import 'package:pomo/core/features/lesson/presentation/pages/lesson_result_page.dart';
import 'package:pomo/core/features/admin/presentation/bloc/lesson_bloc.dart';
import 'package:pomo/core/features/lesson/presentation/entities/lesson_completion_result.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';
import 'package:pomo/services/lesson_progress_service.dart';

class LessonPage extends StatefulWidget {
  final Map<String, dynamic> licao;
  final List<dynamic>? atividades;

  const LessonPage({super.key, required this.licao, this.atividades});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final LessonProgressService _lessonProgressService = LessonProgressService();

  int stepIndex = 0;
  int acertos = 0;
  int erros = 0;
  int vidasAtuais = 5;
  bool isSubmittingCompletion = false;
  String? completionError;
  LessonCompletionResult? completionResult;
  final List<Map<String, dynamic>> respostas = [];
  UserProfileData? _profileBeforeCompletion;

  @override
  void initState() {
    super.initState();
    vidasAtuais = context.read<UserProfileBloc>().state.profile?.lives ?? 5;

    final titulo = widget.licao['titulo'] ?? widget.licao['tituloLicao'];
    if (titulo != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<LessonBloc>().add(LoadLessonDetails(titulo));
      });
    }
  }

  Future<void> _submitLessonCompletion(int lessonId) async {
    _profileBeforeCompletion ??= context.read<UserProfileBloc>().state.profile;

    try {
      final result = await _lessonProgressService.completeLesson(
        lessonId: lessonId,
        responses: respostas,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        completionResult = result;
        completionError = null;
        isSubmittingCompletion = false;
        vidasAtuais = result.remainingLives;
      });

      await context.read<UserProfileBloc>().loadProfile(force: true);
    } catch (error) {
      final recoveredResult = await _recoverCompletionFromProfile();

      if (!mounted) {
        return;
      }

      if (recoveredResult != null) {
        setState(() {
          completionResult = recoveredResult;
          completionError = null;
          isSubmittingCompletion = false;
          vidasAtuais = recoveredResult.remainingLives;
        });
        return;
      }

      setState(() {
        completionError =
            'Nao foi possivel confirmar a conclusao com o servidor. Para evitar XP, progresso ou conquistas duplicadas, o app nao reenviou automaticamente suas respostas.';
        isSubmittingCompletion = false;
      });
    }
  }

  Future<LessonCompletionResult?> _recoverCompletionFromProfile() async {
    final before = _profileBeforeCompletion;
    if (before == null) {
      return null;
    }

    if (acertos + erros != respostas.length) {
      return null;
    }

    await context.read<UserProfileBloc>().loadProfile(force: true);
    final after = context.read<UserProfileBloc>().state.profile;

    if (after == null) {
      return null;
    }

    final previousAchievementIds = before.achievements
        .map((achievement) => achievement.id)
        .toSet();
    final newAchievements = after.achievements
        .where((achievement) =>
            !previousAchievementIds.contains(achievement.id))
        .toList(growable: false);

    final didLikelyPersist =
        after.completedLessons > before.completedLessons ||
        after.solvedExercises >= before.solvedExercises + respostas.length ||
        after.xp > before.xp ||
        after.lives != before.lives ||
        after.streakDays > before.streakDays ||
        newAchievements.isNotEmpty;

    if (!didLikelyPersist) {
      return null;
    }

    final earnedXp = after.xp > before.xp ? after.xp - before.xp : 0;

    return LessonCompletionResult(
      correctAnswers: acertos,
      wrongAnswers: erros,
      earnedXp: earnedXp,
      totalXp: after.xp,
      gainedStreak: after.streakDays > before.streakDays,
      remainingLives: after.lives,
      currentStreak: after.streakDays,
      xpByActivity: const [],
      newAchievements: newAchievements,
    );
  }

  void _retryLessonDetails(String? title) {
    if (title == null || title.trim().isEmpty) {
      return;
    }

    context.read<LessonBloc>().add(LoadLessonDetails(title));
  }

  Future<void> _syncCompletionStatus() async {
    if (!mounted) {
      return;
    }

    setState(() {
      isSubmittingCompletion = true;
      completionError = null;
    });

    final recoveredResult = await _recoverCompletionFromProfile();

    if (!mounted) {
      return;
    }

    if (recoveredResult != null) {
      setState(() {
        completionResult = recoveredResult;
        isSubmittingCompletion = false;
        vidasAtuais = recoveredResult.remainingLives;
      });
      return;
    }

    setState(() {
      isSubmittingCompletion = false;
      completionError =
          'Ainda nao foi possivel confirmar a sincronizacao da licao. Volte para a trilha e tente novamente quando a conexao estiver estavel.';
    });
  }

  Future<void> nextStep({
    required int activityId,
    required int? selectedAlternativeId,
    required bool? acertou,
    required int totalActivities,
    required int lessonId,
  }) async {
    if (acertou == true) {
      acertos++;
    } else if (acertou == false) {
      erros++;
    }

    respostas.add({
      'atividadeId': activityId,
      'alternativaEscolhidaId': selectedAlternativeId,
    });

    final isLastActivity = respostas.length >= totalActivities;

    if (isLastActivity) {
      _profileBeforeCompletion ??= context.read<UserProfileBloc>().state.profile;
    }

    setState(() {
      stepIndex++;
      if (isLastActivity) {
        isSubmittingCompletion = true;
        completionError = null;
      }
    });

    if (isLastActivity) {
      await _submitLessonCompletion(lessonId);
    }
  }

  void nextConceptStep() {
    setState(() {
      stepIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonBloc, LessonState>(
      builder: (context, state) {
        final lessonTitle =
            (widget.licao['titulo'] ?? widget.licao['tituloLicao'])?.toString();

        if (state.isLoading && state.lessonDetails == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5EEDA),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE32626)),
            ),
          );
        }

        if (state.lessonDetails == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5EEDA),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.cloud_off_outlined,
                        size: 72,
                        color: Color(0xFFE32626),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage ??
                            'Nao foi possivel carregar os detalhes da licao.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _retryLessonDetails(lessonTitle),
                        child: const Text('Tentar novamente'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Voltar para a trilha'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        final details = state.lessonDetails!;
        final int lessonId =
            details['licaoId'] ??
            details['LicaoId'] ??
            widget.licao['licaoId'] ??
            0;

        final String textoConceito =
            details['textoConceito'] ??
            details['TextoConceito'] ??
            details['texto_conceito'] ??
            '';
        final String tituloLicao =
            details['tituloLicao'] ??
            details['TituloLicao'] ??
            widget.licao['titulo'] ??
            'Lição';
        final int ordemLicao =
            details['ordem'] ?? details['Ordem'] ?? widget.licao['ordem'] ?? 1;

        final List<dynamic> atividades =
            details['questoes'] ?? details['Questoes'] ?? [];

        final bool hasConcept = textoConceito.trim().isNotEmpty;
        final bool isFinalExam = false;

        if (isSubmittingCompletion) {
          return const Scaffold(
            backgroundColor: Color(0xFFF5EEDA),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFE32626)),
            ),
          );
        }

        if (completionError != null) {
          return Scaffold(
            backgroundColor: const Color(0xFFF5EEDA),
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 72,
                        color: Color(0xFFE32626),
                      ),
                      const SizedBox(height: 16),
                      Text(completionError!, textAlign: TextAlign.center),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _syncCompletionStatus,
                        child: const Text('Sincronizar perfil'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Voltar para a trilha'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (completionResult != null) {
          return LessonResultPage(
            key: const ValueKey('result'),
            acertos: completionResult!.correctAnswers,
            erros: completionResult!.wrongAnswers,
            xpGanho: completionResult!.earnedXp,
            ganhouSequencia: completionResult!.gainedStreak,
            vidasAtuais: completionResult!.remainingLives,
            vidasTotal: 5,
            novasConquistas: completionResult!.newAchievements,
          );
        }

        Widget currentPage;

        if (hasConcept && !isFinalExam && stepIndex == 0) {
          currentPage = LessonConceptPage(
            key: const ValueKey('concept'),
            ordem: ordemLicao,
            titulo: tituloLicao,
            texto: textoConceito,
            onNext: nextConceptStep,
          );
        } else {
          final questionIndex = hasConcept && !isFinalExam
              ? stepIndex - 1
              : stepIndex;

          if (questionIndex < atividades.length) {
            final atividade = atividades[questionIndex] as Map<String, dynamic>;

            final int atividadeId =
                atividade['atividadeId'] ?? atividade['AtividadeId'] ?? 0;
            final String enunciado =
                atividade['enunciado'] ?? atividade['Enunciado'] ?? '';
            final List<String> alternativas = List<String>.from(
              atividade['alternativas'] ?? atividade['Alternativas'] ?? [],
            );
            final List<int> alternativasIds = List<int>.from(
              atividade['alternativasIds'] ??
                  atividade['AlternativasIds'] ??
                  [],
            );
            final indiceCorretoRaw =
              atividade['indiceCorreta'] ?? atividade['IndiceCorreta'];
            final int? indiceCorreto = indiceCorretoRaw is int
              ? indiceCorretoRaw
              : indiceCorretoRaw is num
              ? indiceCorretoRaw.toInt()
              : int.tryParse(indiceCorretoRaw?.toString() ?? '');

            currentPage = LessonQuestionPage(
              key: ValueKey('question_$questionIndex'),
              ordem: questionIndex + 1,
              titulo: 'Questão',
              pergunta: enunciado,
              isFinalExam: isFinalExam,
              alternativas: alternativas,
              alternativaIds: alternativasIds,
              indiceCorreto: indiceCorreto,
              vidasAtuais: vidasAtuais,
              vidasTotal: 5,
              onNext: (acertou, alternativaEscolhidaId) => nextStep(
                activityId: atividadeId,
                selectedAlternativeId: alternativaEscolhidaId,
                acertou: acertou,
                totalActivities: atividades.length,
                lessonId: lessonId,
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Color(0xFFF5EEDA),
              body: Center(
                child: CircularProgressIndicator(color: Color(0xFFE32626)),
              ),
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
