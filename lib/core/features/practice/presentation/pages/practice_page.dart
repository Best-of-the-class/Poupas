import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/widgets/card_practice_exercise.dart';
import 'package:pomo/core/widgets/card_lesson_topic.dart';

/// ✅ MOCK DE EXERCÍCIOS
const List<Map<String, dynamic>> mockExercises = [
  {
    "ordem": 1,
    "titulo": "Juros Simples",
    "type": LessonType.questao
  },
  {
    "ordem": 2,
    "titulo": "Juros Compostos",
    "type": LessonType.questao
  },
  {
    "ordem": 3,
    "titulo": "Revisão Geral",
    "type": LessonType.prova
  },
];

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  int? openedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
            size: 32,
          ),
          onPressed: () {
            context.pop();
          },
        ),

        title: Text(
          'Prática',
          style: AppTextStyles.title.copyWith(
            fontSize: 20,
            color: AppColors.title,
          ),
        ),

        centerTitle: true,
      ),

      /// ✅ BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            children: [
              const SizedBox(height: 10),

              Text(
                'Selecione abaixo exercícios para revisão',
                textAlign: TextAlign.center,
                style: AppTextStyles.body.copyWith(
                  fontSize: 14,
                  color: AppColors.textDark,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 20),

              /// ✅ LISTA OU EMPTY STATE
              Expanded(
                child: mockExercises.isEmpty
                    ? const _EmptyState()
                    : ListView.builder(
                        itemCount: mockExercises.length,
                        itemBuilder: (context, index) {
                          final exercise = mockExercises[index];

                          return CardPracticeExercise(
                            ordem: exercise['ordem'],
                            titulo: exercise['titulo'],
                            type: exercise['type'],
                            isOpen: openedIndex == index,

                            /// 🎯 ACCORDION
                            onTap: () {
                              setState(() {
                                if (openedIndex == index) {
                                  openedIndex = null;
                                } else {
                                  openedIndex = index;
                                }
                              });
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ✅ ESTADO VAZIO
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 80,
            color: AppColors.textDark.withOpacity(0.4),
          ),

          const SizedBox(height: 20),

          Text(
            'Nenhum exercício disponível ainda.\nContinue estudando para liberar práticas!',
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}