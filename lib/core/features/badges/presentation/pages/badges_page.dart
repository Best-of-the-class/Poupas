import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/widgets/badge_card.dart';
import 'package:pomo/core/features/badges/presentation/pages/badge_unlocked_page.dart';

class BadgesPage extends StatelessWidget {
  const BadgesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: BadgesContent(),
    );
  }
}

class BadgesContent extends StatelessWidget {
  const BadgesContent({super.key});



  final List<Map<String, dynamic>> badges = const [
    {
      "titulo": "Primeiros passos",
      "descricao": "Completou sua primeira lição",
      "icone": "pencil",
      "background_cor": "green"
    },
    {
      "titulo": "Poup Aprendiz",
      "descricao": "10 respostas corretas",
      "icone": "student",
      "background_cor": "blue"
    },
    {
      "titulo": "Megamente",
      "descricao": "50 respostas corretas",
      "icone": "megamente",
      "background_cor": "blue"
    },
    {
      "titulo": "Poup Guru",
      "descricao": "100 respostas corretas",
      "icone": "guru",
      "background_cor": "blue"
    },
    {
      "titulo": "Imparável",
      "descricao": "10 acertos seguidos",
      "icone": "pencil",
      "background_cor": "green"
    },
    {
      "titulo": "Sequência de ouro",
      "descricao": "Sequência de 30 dias",
      "icone": "calendar",
      "background_cor": "red"
    },
    {
      "titulo": "Poup Lendário",
      "descricao": "Sequência de 100 dias",
      "icone": "calendar",
      "background_cor": "red"
    },
    {
      "titulo": "Caçador de Juros",
      "descricao": "Aprendeu sobre Juros Simples",
      "icone": "dollar",
      "background_cor": "green"
    },
    {
      "titulo": "Poupador",
      "descricao": "Ganhou 1500XP",
      "icone": "lending",
      "background_cor": "yellow"
    },
    {
      "titulo": "Maratonista",
      "descricao": "Completou 5 lições em 1 dia",
      "icone": "run",
      "background_cor": "yellow"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              'Conquistas',
              textAlign: TextAlign.center,
              style: AppTextStyles.title.copyWith(
                fontSize: 20,
                color: AppColors.title,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Você é incrível demais! Veja abaixo todas as suas conquistas.',
              textAlign: TextAlign.justify,
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),

            // // botão de teste da debora para mostrar a screen de conquista desbloqueada, pode remover depois
            // ElevatedButton(
            //   onPressed: () {
            //     BadgeUnlockedPage.show(
            //       context,
            //       titulo: 'Primeiros passos',
            //       descricao: 'Completou sua primeira lição',
            //       iconName: 'pencil',
            //       backgroundColor: AppColors.badgeGreen,
            //     );
            //   },
            //   child: const Text('Testar conquista'),
            // ),

            const SizedBox(height: 40),

            Expanded(
              child: badges.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.workspace_premium_outlined,
                            size: 90,
                            color: AppColors.primary.withOpacity(0.3),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            'Você ainda não desbloqueou nenhuma conquista. Continue aprendendo e deixe Poup orgulhoso!',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 16,
                              color: AppColors.textDark,
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(bottom: 120),
                      itemCount: badges.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final badge = badges[index];

                        return BadgeCard(
                          titulo: badge['titulo'],
                          descricao: badge['descricao'],
                          iconName: badge['icone'],
                          backgroundColorKey: badge['background_cor'],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}