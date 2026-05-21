import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'stats_card.dart';

class StatsSection extends StatelessWidget {
  final int completedLessons;
  final int solvedExercises;
  final int xp;
  final int streakDays;

  const StatsSection({
    super.key,
    required this.completedLessons,
    required this.solvedExercises,
    required this.xp,
    required this.streakDays,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          StatsCard(
            value: completedLessons,
            label: "Lições concluídas",
            color: AppColors.perfilLicoes,
            icon: Icons.menu_book_outlined,
          ),
          StatsCard(
            value: solvedExercises,
            label: "Exercícios resolvidos",
            color: AppColors.perfilExercicios,
            icon: Icons.edit_outlined,
          ),
          StatsCard(
            value: xp,
            label: "Pontuação (XP)",
            color: AppColors.perfilPontuacao,
            icon: Icons.star_outline,
          ),
          StatsCard(
            value: streakDays,
            label: "Sequência de dias",
            color: AppColors.perfilSequencia,
            icon: Icons.local_fire_department_outlined,
          ),
        ],
      ),
    );
  }
}
