import 'package:flutter/material.dart';
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
        children: [
          StatsCard(
            value: 20,
            label: "Lições concluídas",
            color: Color(0xFFA2CA8B),
            icon: Icons.menu_book_outlined,
          ),
          StatsCard(
            value: 35,
            label: "Exercícios resolvidos",
            color: Color(0xFF7ECCE1),
            icon: Icons.edit_outlined,
          ),
          StatsCard(
            value: 2584,
            label: "Pontuação (XP)",
            color: Color(0xFFFBD564),
            icon: Icons.star_outline,
          ),
          StatsCard(
            value: 14,
            label: "Sequência de dias",
            color: Color(0xFFFBA29B),
            icon: Icons.local_fire_department_outlined,
          ),
        ]
      ),
    );
  }
}