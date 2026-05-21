import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class BadgePreviewOverlay extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String iconName;
  final Color backgroundColor;

  const BadgePreviewOverlay({
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "badge",
      barrierColor: Colors.black.withOpacity(0.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return BadgePreviewOverlay(
          titulo: titulo,
          descricao: descricao,
          iconName: iconName,
          backgroundColor: backgroundColor,
        );
      },
      transitionBuilder: (context, anim, _, child) {
        return FadeTransition(
          opacity: anim,
          child: child,
        );
      },
    );
  }

  @override
  State<BadgePreviewOverlay> createState() => _BadgePreviewOverlayState();
}

class _BadgePreviewOverlayState extends State<BadgePreviewOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scale = CurvedAnimation(
      parent: controller,
      curve: Curves.easeOutBack,
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  String get iconPath =>
      'lib/core/features/badges/presentation/assets/${widget.iconName}.png';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor.withOpacity(0.65),

      child: GestureDetector(
        onTap: () => Navigator.pop(context),

        child: Center(
          child: ScaleTransition(
            scale: scale,

          child: Container(
              width: 340,
              height: 400,
              padding: const EdgeInsets.all(20), 
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.titulo,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.title.copyWith(
                          fontSize: 32,
                          color: Colors.white,
                        ),
                      ),

                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(
                          iconPath,
                          fit: BoxFit.contain,
                        )
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6, right: 45),
                          child: Text(
                            widget.descricao,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        )
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'lib/core/assets/icons/icon-poup-circle.png',
                      width: 36,
                      height: 36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}