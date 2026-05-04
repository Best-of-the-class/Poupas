import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'stats_card.dart';

class StatsSection extends StatelessWidget {
  final int licoesConcluidas;
  final int exerciciosResolvidos;
  final int pontuacao;
  final int sequenciaDias;

  const StatsSection({
    super.key,
    required this.licoesConcluidas,
    required this.exerciciosResolvidos,
    required this.pontuacao,
    required this.sequenciaDias,
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
            value: licoesConcluidas,
            label: "Lições concluídas",
            color: AppColors.perfilLicoes,
            icon: Icons.menu_book_outlined,
          ),
          StatsCard(
            value: exerciciosResolvidos,
            label: "Exercícios resolvidos",
            color: AppColors.perfilExercicios,
            icon: Icons.edit_outlined,
          ),
          StatsCard(
            value: pontuacao,
            label: "Pontuação (XP)",
            color: AppColors.perfilPontuacao,
            icon: Icons.star_outline,
          ),
          StatsCard(
            value: sequenciaDias,
            label: "Sequência de dias",
            color: AppColors.perfilSequencia,
            icon: Icons.local_fire_department_outlined,
          ),
        ],
      ),
    );
  }
}
