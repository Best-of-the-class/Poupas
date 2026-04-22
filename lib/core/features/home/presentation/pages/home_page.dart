import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/widgets/card_stats_home.dart';
import 'package:pomo/core/widgets/card_module.dart';
import 'package:pomo/core/widgets/trail_module.dart';

final mockLessons = [
  {'ordem': 1, 'titulo': 'Introdução do Curso', 'level': 1},
  {'ordem': 2, 'titulo': 'O que é Educação Financeira', 'level': 1},
  {'ordem': 3, 'titulo': 'Renda e Despesas', 'level': 1},
  {'ordem': 4, 'titulo': 'Organizando seu Orçamento', 'level': 1},
  {'ordem': 5, 'titulo': 'Consumo Consciente', 'level': 1},
  {'ordem': 6, 'titulo': 'Mas por que economizar?', 'level': 1},

  {'ordem': 7, 'titulo': 'Juros Simples', 'level': 2},
  {'ordem': 8, 'titulo': 'Juros Compostos', 'level': 2},
  {'ordem': 9, 'titulo': 'Diferença entre Juros', 'level': 2},
  {'ordem': 10, 'titulo': 'Inflação na Prática', 'level': 2},
  {'ordem': 11, 'titulo': 'Poder de Compra', 'level': 2},
  {'ordem': 12, 'titulo': 'Planejamento Financeiro', 'level': 2},

  {'ordem': 13, 'titulo': 'Introdução aos Investimentos', 'level': 3},
  {'ordem': 14, 'titulo': 'Renda Fixa', 'level': 3},
  {'ordem': 15, 'titulo': 'Renda Variável', 'level': 3},
  {'ordem': 16, 'titulo': 'Diversificação', 'level': 3},
  {'ordem': 17, 'titulo': 'Perfil de Investidor', 'level': 3},
  {'ordem': 18, 'titulo': 'Planejamento de Longo Prazo', 'level': 3},
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: HomeContent(),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final modulos = [1, 2, 3];

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'lib/core/assets/images/background-arvore-trilha.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              const CardStatsHome(
                sequenciaDias: 14,
                xp: 2584,
              ),

              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...modulos.map((level) {
                        final lessonsDoModulo = mockLessons
                            .where((l) => l['level'] == level)
                            .toList();

                        if (lessonsDoModulo.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            CardModule(level: level),

                            const SizedBox(height: 10),

                            TrailModule(lessons: lessonsDoModulo),

                            const SizedBox(height: 40),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}