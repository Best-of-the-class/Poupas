import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../widgets/choice.dart';
import '../../../../widgets/custom_editor.dart';
import '../../../../widgets/missing_question.dart';
import '../../../../widgets/question.dart';
import '../../../../widgets/wide_button.dart';

class QuestionItem {
  final String title;
  final String subtitle;
  bool isSelected;

  QuestionItem({
    required this.title,
    required this.subtitle,
    this.isSelected = false,
  });
}

class AdminQuestions extends StatefulWidget {
  const AdminQuestions({super.key});

  @override
  State<AdminQuestions> createState() => _AdminQuestionsState();
}

class _AdminQuestionsState extends State<AdminQuestions> {
  final Color themeColor = const Color(0xFFE32626);
  final List<TextEditingController> _choiceControllers = List.generate(
    3,
    (_) => TextEditingController(),
  );
  int _selectedCorrectIndex = 1;

  final List<QuestionItem> _questions = [
    QuestionItem(
      title: "Questão 1 criada!",
      subtitle: "Adicionar questão na prova?",
      isSelected: false,
    ),
    QuestionItem(
      title: "Questão 2 criada!",
      subtitle: "Adicionar questão na prova?",
      isSelected: true,
    ),
  ];

  final int _totalQuestions = 4;

  @override
  void initState() {
    super.initState();
    _setupWindow();
  }

  void _setupWindow() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1366, 768),
      minimumSize: Size(1366, 768),
      maximumSize: Size(1366, 768),
      center: true,
      title: "Poupas Admin",
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setResizable(false);
    });
  }

  @override
  void dispose() {
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleQuestion(int index) {
    setState(
      () => _questions[index].isSelected = !_questions[index].isSelected,
    );
  }

  void _deleteQuestion(int index) {
    setState(() => _questions.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final missingCount = _totalQuestions - _questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EEDA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Agora crie 4 questões",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  WideButton(text: "Criar Aula", onPress: () {}),
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
                          Expanded(child: CustomEditor(themeColor: themeColor)),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "Digite as alternativas e marque a correta",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ...List.generate(3, (index) {
                            return Choice(
                              letter: String.fromCharCode(65 + index),
                              controller: _choiceControllers[index],
                              isSelected: _selectedCorrectIndex == index,
                              isCorrect: _selectedCorrectIndex == index,
                              themeColor: themeColor,
                              onSelected: () {
                                setState(() => _selectedCorrectIndex = index);
                              },
                            );
                          }),
                          const SizedBox(height: 12),
                          WideButton(
                            text: "Adicionar questão",
                            onPress: () {},
                            backgroundColor: themeColor,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40),
                    Expanded(
                      flex: 4,
                      child: ScrollConfiguration(
                        behavior: const ScrollBehavior().copyWith(
                          scrollbars: false,
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ...List.generate(_questions.length, (index) {
                              final q = _questions[index];
                              return Question(
                                title: q.title,
                                subtitle: q.subtitle,
                                isSelected: q.isSelected,
                                onToggle: () => _toggleQuestion(index),
                                onDelete: () => _deleteQuestion(index),
                              );
                            }),
                            ...List.generate(missingCount, (_) {
                              return const MissingQuestion(
                                themeColor: Color(0xFF2E7D32),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
