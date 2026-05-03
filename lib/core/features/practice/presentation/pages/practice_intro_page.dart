import 'package:flutter/material.dart';
import 'package:pomo/core/layouts/main_layout.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/widgets/shortcut_card.dart';

class PracticeIntroPage extends StatelessWidget {
  const PracticeIntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainLayout(
      child: PracticeIntroContent(),
    );
  }
}

class PracticeIntroContent extends StatelessWidget {
  const PracticeIntroContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 20,
              bottom: 120,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // BOTÃO DICIONÁRIO
                ShortcutCard(
                  titulo: "Dicionário de Termos",
                  descricao: "Consulte palavras-chave",
                  imagePath:
                      "lib/core/assets/icons/icon-btn-dicionario.png",
                  backgroundColor: AppColors.shortcutDictionary,
                  onTap: () {
                    // TODO: navegar para dicionário
                  },
                ),

                const SizedBox(height: 40),

                // BOTÃO PRÁTICA
                ShortcutCard(
                  titulo: "Prática",
                  descricao: "Reveja seus erros e se desafie!",
                  imagePath:
                      "lib/core/assets/icons/icon-btn-pratica.png",
                  backgroundColor: AppColors.shortcutPractice,
                  onTap: () {
                    // TODO: navegar para prática
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}