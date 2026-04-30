import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/widgets/badge_preview_overlay.dart';

class BadgeCard extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String iconName;
  final String backgroundColorKey;

  const BadgeCard({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.iconName,
    required this.backgroundColorKey,
  });

  String get iconPath =>
      'lib/core/features/badges/presentation/assets/$iconName.png';

  Color get backgroundColor {
    switch (backgroundColorKey) {
      case 'blue':
        return AppColors.badgeBlue;
      case 'green':
        return AppColors.badgeGreen;
      case 'red':
        return AppColors.badgeRed;
      case 'yellow':
        return AppColors.badgeYellow;
      default:
        return AppColors.surface;
    }
  }

  void _openPreview(BuildContext context) {
    BadgePreviewOverlay.show(
      context,
      titulo: titulo,
      descricao: descricao,
      iconName: iconName,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPreview(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),

          // 🌟 SOMBRA ADICIONADA
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titulo,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                  ),
                ),

                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 6, right: 35),
                    child: Text(
                      descricao,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset(
                'lib/core/assets/icons/icon-poup-circle.png',
                width: 30,
                height: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}