import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:go_router/go_router.dart';
import '../../../../widgets/choice.dart';
import '../../../../widgets/custom_editor.dart';
import '../../../../widgets/missing_question.dart';
import '../../../../widgets/question.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/module.dart';
import '../../../../network/adapters/routes_adapter.dart';
import '../bloc/question_bloc.dart';
import '../bloc/lesson_bloc.dart';

class AdminQuestions extends StatefulWidget {
  final ModuleDifficulty difficulty;
  const AdminQuestions({super.key, required this.difficulty});

  @override
  State<AdminQuestions> createState() => _AdminQuestionsState();
}

class _AdminQuestionsState extends State<AdminQuestions> {
  final Color themeColor = const Color(0xFFE32626);
  final GlobalKey<CustomEditorState> _editorKey =
      GlobalKey<CustomEditorState>();
  final TextEditingController _titleController = TextEditingController();
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
  }

  void _setupWindow() async {
    await windowManager.ensureInitialized();
    const windowOptions = WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1366, 768),
      maximumSize: Size(1366, 768),
      center: true,
      title: 'Poupas Admin',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _choiceControllers) c.dispose();
    super.dispose();
  }

  void _createLesson(BuildContext context, AdminQuestionsState state) {
    final title = _titleController.text.trim().isEmpty
        ? 'Nova Aula'
        : _titleController.text.trim();

    AdminQuestionsBloc.persistForLesson(title, state.questions);

    context.read<LessonBloc>().add(CreateLesson(title, widget.difficulty));
    context.goNamed(RoutesAdapter.adminSuccess);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: BlocListener<AdminQuestionsBloc, AdminQuestionsState>(
        listenWhen: (prev, curr) =>
            prev.questions.length != curr.questions.length,
        listener: (context, state) {
          _editorKey.currentState?.setContent('');
          for (final c in _choiceControllers) c.clear();
          setState(() => _selectedCorrectIndex = 0);
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Agora crie 4 questões',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              hintText: 'Título da Aula',
                              border: UnderlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<AdminQuestionsBloc, AdminQuestionsState>(
                      builder: (context, state) {
                        final isComplete =
                            state.questions.length == _totalQuestions;
                        return WideButton(
                          text: 'Criar Aula',
                          backgroundColor: isComplete
                              ? const Color(0xFF2E7D32)
                              : Colors.grey,
                          onPress: isComplete
                              ? () => _createLesson(context, state)
                              : () {},
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
                                'Digite as alternativas e marque a correta',
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
                            WideButton(
                              text: 'Adicionar questão',
                              backgroundColor: themeColor,
                              onPress: () {
                                context.read<AdminQuestionsBloc>().add(
                                  SaveQuestion(
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
                                    correctIndex: _selectedCorrectIndex,
                                  ),
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
                                final missingCount =
                                    _totalQuestions - state.questions.length;
                                return ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    ...List.generate(state.questions.length, (
                                      index,
                                    ) {
                                      final q = state.questions[index];
                                      return Question(
                                        title: q.title,
                                        subtitle: q.subtitle,
                                        isSelected: q.isSelected,
                                        onToggle: () => context
                                            .read<AdminQuestionsBloc>()
                                            .add(
                                              ToggleQuestionSelection(index),
                                            ),
                                        onDelete: () => context
                                            .read<AdminQuestionsBloc>()
                                            .add(DeleteQuestion(index)),
                                      );
                                    }),
                                    ...List.generate(
                                      missingCount,
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
