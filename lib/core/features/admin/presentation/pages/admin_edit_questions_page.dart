import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../widgets/choice.dart';
import '../../../../widgets/custom_editor.dart';
import '../../../../widgets/missing_question.dart';
import '../../../../widgets/question.dart';
import '../../../../widgets/wide_button.dart';
import '../bloc/question_bloc.dart';

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

  @override
  void initState() {
    super.initState();
    _setupWindow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.lessonTitle != null) {
        context.read<AdminQuestionsBloc>().add(
          LoadQuestionsByLesson(widget.lessonTitle!),
        );
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

  @override
  void dispose() {
    for (final c in _choiceControllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: BlocListener<AdminQuestionsBloc, AdminQuestionsState>(
        listenWhen: (prev, curr) => prev.viewingIndex != curr.viewingIndex,
        listener: (context, state) {
          if (state.viewingIndex != null) {
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.lessonTitle != null
                          ? 'Editando: ${widget.lessonTitle}'
                          : 'Edite suas questões',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D2D2D),
                      ),
                    ),
                    WideButton(
                      text: 'Finalizar Edição',
                      onPress: () => Navigator.pop(context),
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
                                      ? 'Salvar Alterações'
                                      : 'Selecione uma questão',
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
                        child:
                            BlocBuilder<
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
                                              .add(
                                                ToggleQuestionSelection(index),
                                              ),
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
