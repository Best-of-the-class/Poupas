import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class AppleNode extends StatelessWidget {
  final int ordem;
  final String titulo;
  final int level;
  final bool isLastInModule;
  final bool isLocked;
  final bool isProva;

  const AppleNode({
    super.key,
    required this.ordem,
    required this.titulo,
    required this.level,
    this.isLastInModule = false,
    this.isLocked = false,
    this.isProva = false,
  });

  void _showLessonPopup(BuildContext context) {
    if (isLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Conclua a lição anterior para desbloquear!'),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 2),
        ),
      );
      return; 
    }

    showDialog(
      context: context,
      builder: (_) {
        return _LessonPopup(
          titulo: titulo,
          ordem: ordem,
          level: level,
          isLastInModule: isLastInModule,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: () => _showLessonPopup(context),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              isProva 
                  ? 'lib/core/assets/icons/icon-iniciar-prova-final.png' 
                  : 'lib/core/assets/icons/icon-maca-trilha.png',
              width: isProva ? 100 : 92,
            ),
            
            if (!isLocked && !isProva)
              Text(
                '$ordem',
                style: AppTextStyles.body.copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

            if (isLocked)
               const Icon(Icons.lock_rounded, color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}

class _LessonPopup extends StatefulWidget {
  final String titulo;
  final int ordem;
  final int level;
  final bool isLastInModule;

  const _LessonPopup({
    required this.titulo,
    required this.ordem,
    required this.level,
    this.isLastInModule = false, 
  });

  @override
  State<_LessonPopup> createState() => _LessonPopupState();
}

class _LessonPopupState extends State<_LessonPopup> {
  bool isLoading = false;

  void _handleStart(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    Navigator.pop(context);
    context.push(
      '/lesson',
      extra: {
        'licao': {
          'ordem': widget.ordem,
          'titulo': widget.titulo, 
        },
        'atividades': [],
      },
    );
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
                onPressed: isLoading ? null : () => _handleStart(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
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
                : const Text('Iniciar aula', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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

          Expanded(
            child: Column(
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
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}