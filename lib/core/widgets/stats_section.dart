import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'stats_card.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

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
        children: const [
          StatsCard(
            value: 20,
            label: "Lições concluídas",
            color: AppColors.perfilLicoes,
            icon: Icons.menu_book_outlined,
          ),
          StatsCard(
            value: 35,
            label: "Exercícios resolvidos",
            color: AppColors.perfilExercicios,
            icon: Icons.edit_outlined,
          ),
          StatsCard(
            value: 2584,
            label: "Pontuação (XP)",
            color: AppColors.perfilPontuacao,
            icon: Icons.star_outline,
          ),
          StatsCard(
            value: 14,
            label: "Sequência de dias",
            color: AppColors.perfilSequencia,
            icon: Icons.local_fire_department_outlined,
          ),
        ],
      ),
    );
  }
}
