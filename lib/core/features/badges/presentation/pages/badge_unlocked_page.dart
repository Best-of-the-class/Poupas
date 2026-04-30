import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class BadgeUnlockedPage extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String iconName;
  final Color backgroundColor;

  const BadgeUnlockedPage({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.iconName,
    required this.backgroundColor,
  });

  static void show(
    BuildContext context, {
    required String titulo,
    required String descricao,
    required String iconName,
    required Color backgroundColor,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, __, ___) => BadgeUnlockedPage(
          titulo: titulo,
          descricao: descricao,
          iconName: iconName,
          backgroundColor: backgroundColor,
        ),
        transitionsBuilder: (_, anim, __, child) {
          return FadeTransition(
            opacity: anim,
            child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: anim, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  State<BadgeUnlockedPage> createState() => _BadgeUnlockedPageState();
}

class _BadgeUnlockedPageState extends State<BadgeUnlockedPage> {
  String get iconPath =>
      'lib/core/features/badges/presentation/assets/${widget.iconName}.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.backgroundColor,

        body: SafeArea(
        child: Column(
            children: [
            const SizedBox(height: 20),

            Text(
                'Conquista Desbloqueada!',
                textAlign: TextAlign.center,
                style: AppTextStyles.title.copyWith(
                fontSize: 20,
                color: Colors.white,
                ),
            ),

            Expanded(
                child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Text(
                        widget.titulo,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                        ),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                        iconPath,
                        fit: BoxFit.contain,
                    ),
                    ),

                    const SizedBox(height: 30),

                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                        widget.descricao,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                        ),
                        ),
                    ),
                    ],
                ),
                ),
            ),

            Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                    ),
                    ),
                    child: Text(
                    'Legal!',
                    style: AppTextStyles.body.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                    ),
                ),
                ),
            ),
            ],
        ),
        ),
    );
  }
}