import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class AppleNode extends StatelessWidget {
  final int ordem;
  final String titulo;
  final int level;

  const AppleNode({
    super.key,
    required this.ordem,
    required this.titulo,
    required this.level,
  });

  void _showLessonPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return _LessonPopup(
        titulo: titulo,
        ordem: ordem,
        level: level,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLessonPopup(context),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'lib/core/assets/icons/icon-maca-trilha.png',
            width: 92,
          ),
          Text(
            '$ordem',
            style: AppTextStyles.body.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonPopup extends StatefulWidget {
  final String titulo;
  final int ordem;
  final int level;

  const _LessonPopup({
    required this.titulo,
    required this.ordem,
    required this.level,
  });

  @override
  State<_LessonPopup> createState() => _LessonPopupState();
}

class _LessonPopupState extends State<_LessonPopup> {
  bool isLoading = false;

  void _handleStart() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LessonBadge(
              ordem: widget.ordem,
              level: widget.level,
            ),

            const SizedBox(height: 12),

            Text(
              widget.titulo,
              style: AppTextStyles.title,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _handleStart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                  disabledForegroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
              child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text('Iniciar aula'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonBadge extends StatelessWidget {
  final int ordem;
  final int level;

  const _LessonBadge({
    required this.ordem,
    required this.level,
  });

  String get title {
    switch (level) {
      case 1:
        return 'Poup Iniciante';
      case 2:
        return 'Poup Intermediário';
      case 3:
        return 'Poup Avançado';
      default:
        return 'Módulo';
    }
  }

  String get iconPath {
    switch (level) {
      case 1:
        return 'lib/core/assets/icons/icon-modulo-iniciante.png';
      case 2:
        return 'lib/core/assets/icons/icon-modulo-intermediario.png';
      case 3:
        return 'lib/core/assets/icons/icon-modulo-avancado.png';
      default:
        return '';
    }
  }

  Color get backgroundColor {
    switch (level) {
      case 1:
        return AppColors.moduloIniciante;
      case 2:
        return AppColors.moduloIntermediario;
      case 3:
        return AppColors.moduloAvancado;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 30,
            height: 30,
          ),

          const SizedBox(width: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LIÇÃO #$ordem',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                '$title | Módulo $level',
                style: AppTextStyles.body.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}