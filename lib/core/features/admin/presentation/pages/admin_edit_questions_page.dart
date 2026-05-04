import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/choice.dart';
import '../../../../widgets/custom_editor.dart';
import '../../../../widgets/missing_question.dart';
import '../../../../widgets/question.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/pop_up.dart';
import '../../../../widgets/navigate_top_corner.dart';
import '../entities/question_item.dart';
import '../bloc/question_bloc.dart';
import '../bloc/lesson_bloc.dart';

class AdminEditQuestions extends StatefulWidget {
  final String? lessonTitle;
  const AdminEditQuestions({super.key, this.lessonTitle});

  @override
  State<AdminEditQuestions> createState() => _AdminEditQuestionsState();
}

class _AdminEditQuestionsState extends State<AdminEditQuestions> {
  final Color themeColor = const Color(0xFFE32626);
  final GlobalKey<CustomEditorState> _editorKey =
      GlobalKey<CustomEditorState>();
  final List<TextEditingController> _choiceControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  int _selectedCorrectIndex = 0;
  final int _totalQuestions = 4;
  bool _isPopupOpen = false;

  @override
  void initState() {
    super.initState();
    _setupWindow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.lessonTitle != null) {
        context.read<LessonBloc>().add(LoadLessonDetails(widget.lessonTitle!));
      }
    });
  }

  void _setupWindow() async {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1366, 768),
      maximumSize: Size(1366, 768),
      center: true,
      title: 'Poupas Admin - Editar',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }

  Future<void> _showError(String message) async {
    if (_isPopupOpen) return;
    _isPopupOpen = true;
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      pageBuilder: (context, _, __) => Center(
        child: PopUp(
          title: 'Ops!',
          subtitle: message,
          buttons: [
            WideButton(
              text: 'Entendido',
              onPress: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
    _isPopupOpen = false;
  }

  @override
  void dispose() {
    for (final c in _choiceControllers) c.dispose();
    super.dispose();
  }

  void _finalizarEdicao(
    BuildContext context,
    AdminQuestionsState questionsState,
  ) {
    if (questionsState.questions.length < 4) {
      _showError("A aula precisa ter exatamente 4 questões antes de salvar!");
      return;
    }

    final lessonState = context.read<LessonBloc>().state;
    if (lessonState.lessonDetails == null) return;

    final details = lessonState.lessonDetails!;

    final questoesJson = questionsState.questions
        .map(
          (q) => {
            "enunciado": q.questionText,
            "alternativas": q.choices,
            "indiceCorreta": q.correctIndex,
          },
        )
        .toList();

    final novoTitulo =
        (AdminQuestionsBloc.tempTitle != null &&
            AdminQuestionsBloc.tempTitle!.isNotEmpty)
        ? AdminQuestionsBloc.tempTitle!
        : (details['tituloLicao'] ?? widget.lessonTitle ?? 'Sem Título');

    final novaTeoria =
        (AdminQuestionsBloc.tempTheory != null &&
            AdminQuestionsBloc.tempTheory!.isNotEmpty)
        ? AdminQuestionsBloc.tempTheory!
        : (details['textoConceito'] ?? '');

    context.read<LessonBloc>().add(
      UpdateLesson(
        tituloAntigo: widget.lessonTitle!,
        dificuldade: details['dificuldade'] ?? 0,
        tituloLicao: novoTitulo.toString(),
        textoConceito: novaTeoria.toString(),
        questoes: questoesJson,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LessonBloc, LessonState>(
            listenWhen: (prev, curr) =>
                prev.lessonDetails != curr.lessonDetails ||
                prev.isSuccess != curr.isSuccess,
            listener: (context, state) {
              if (state.isSuccess) {
                context.go('/admin-activities');
              } else if (state.lessonDetails != null) {
                final questoesApi =
                    state.lessonDetails!['questoes'] as List<dynamic>? ?? [];

                final questionsParsed = questoesApi.asMap().entries.map((
                  entry,
                ) {
                  final i = entry.key;
                  final q = entry.value as Map<String, dynamic>? ?? {};

                  final enunciado = q['enunciado'] ?? q['Enunciado'] ?? '';
                  final alternativasRaw =
                      q['alternativas'] ?? q['Alternativas'] ?? [];
                  final alternativasList = (alternativasRaw as List<dynamic>)
                      .map((e) => e?.toString() ?? '')
                      .toList();
                  final indice = q['indiceCorreta'] ?? q['IndiceCorreta'] ?? 0;

                  return QuestionItem(
                    title: 'Questão ${i + 1}',
                    subtitle: 'Questão salva',
                    questionText: enunciado.toString(),
                    choices: alternativasList,
                    correctIndex: indice as int,
                    isSelected: false,
                  );
                }).toList();

                context.read<AdminQuestionsBloc>().add(
                  LoadQuestionsFromApi(questionsParsed),
                );
              }
            },
          ),
          BlocListener<AdminQuestionsBloc, AdminQuestionsState>(
            listenWhen: (prev, curr) =>
                prev.viewingIndex != curr.viewingIndex ||
                prev.errorId != curr.errorId,
            listener: (context, state) {
              if (state.errorMessage != null) {
                _showError(state.errorMessage!);
              } else if (state.viewingIndex != null) {
                final q = state.questions[state.viewingIndex!];
                _editorKey.currentState?.setContent(q.questionText);
                for (int i = 0; i < 3; i++) {
                  _choiceControllers[i].text = i < q.choices.length
                      ? q.choices[i]
                      : '';
                }
                setState(() => _selectedCorrectIndex = q.correctIndex);
              }
            },
          ),
        ],
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
            child: Column(
              children: [
                Row(
                  children: [
                    const NavigateTopCorner(),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        widget.lessonTitle != null
                            ? 'Editando: ${widget.lessonTitle}'
                            : 'Edite suas questões',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D2D2D),
                        ),
                      ),
                    ),
                    BlocBuilder<LessonBloc, LessonState>(
                      builder: (context, lessonState) {
                        return WideButton(
                          text: lessonState.isLoading
                              ? 'Salvando...'
                              : 'Finalizar Edição',
                          backgroundColor: lessonState.isLoading
                              ? Colors.grey
                              : const Color(0xFF2E7D32),
                          onPress: lessonState.isLoading
                              ? () {}
                              : () => _finalizarEdicao(
                                  context,
                                  context.read<AdminQuestionsBloc>().state,
                                ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CustomEditor(
                                key: _editorKey,
                                themeColor: themeColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'Altere as alternativas e a correta',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            ...List.generate(
                              3,
                              (index) => Choice(
                                letter: String.fromCharCode(65 + index),
                                controller: _choiceControllers[index],
                                isSelected: _selectedCorrectIndex == index,
                                isCorrect: _selectedCorrectIndex == index,
                                themeColor: themeColor,
                                onSelected: () => setState(
                                  () => _selectedCorrectIndex = index,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            BlocBuilder<
                              AdminQuestionsBloc,
                              AdminQuestionsState
                            >(
                              builder: (context, state) {
                                final isViewing = state.viewingIndex != null;
                                return WideButton(
                                  text: isViewing
                                      ? 'Salvar Alterações na Questão'
                                      : 'Selecione uma questão na lista',
                                  backgroundColor: isViewing
                                      ? themeColor
                                      : Colors.grey,
                                  onPress: isViewing
                                      ? () {
                                          context
                                              .read<AdminQuestionsBloc>()
                                              .add(
                                                UpdateQuestion(
                                                  index: state.viewingIndex!,
                                                  questionText:
                                                      _editorKey
                                                          .currentState
                                                          ?.controller
                                                          .document
                                                          .toPlainText() ??
                                                      '',
                                                  choices: _choiceControllers
                                                      .map((c) => c.text)
                                                      .toList(),
                                                  correctIndex:
                                                      _selectedCorrectIndex,
                                                ),
                                              );
                                        }
                                      : () {},
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        flex: 4,
                        child: BlocBuilder<LessonBloc, LessonState>(
                          builder: (context, lessonState) {
                            if (lessonState.isLoading &&
                                lessonState.lessonDetails == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFE32626),
                                ),
                              );
                            }

                            return BlocBuilder<
                              AdminQuestionsBloc,
                              AdminQuestionsState
                            >(
                              builder: (context, state) {
                                return ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    ...List.generate(state.questions.length, (
                                      index,
                                    ) {
                                      final q = state.questions[index];
                                      return GestureDetector(
                                        onTap: () => context
                                            .read<AdminQuestionsBloc>()
                                            .add(LoadQuestionForView(index)),
                                        child: Question(
                                          title: q.title,
                                          subtitle: q.subtitle,
                                          isSelected:
                                              state.viewingIndex == index,
                                          onToggle: () => context
                                              .read<AdminQuestionsBloc>()
                                              .add(LoadQuestionForView(index)),
                                          onDelete: () => context
                                              .read<AdminQuestionsBloc>()
                                              .add(DeleteQuestion(index)),
                                        ),
                                      );
                                    }),
                                    ...List.generate(
                                      _totalQuestions - state.questions.length,
                                      (_) => const MissingQuestion(
                                        themeColor: Color(0xFF2E7D32),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
