import 'package:flutter/material.dart';

import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class ModuleConfig {
  final String title;
  final String icon;
  final Color color;

  const ModuleConfig({
    required this.title,
    required this.icon,
    required this.color,
  });
}

const Map<int, ModuleConfig> moduleConfigs = {
  1: ModuleConfig(
    title: 'Poup Iniciante',
    icon: 'lib/core/assets/icons/icon-modulo-iniciante.png',
    color: AppColors.moduloIniciante,
  ),
  2: ModuleConfig(
    title: 'Poup Intermediário',
    icon: 'lib/core/assets/icons/icon-modulo-intermediario.png',
    color: AppColors.moduloIntermediario,
  ),
  3: ModuleConfig(
    title: 'Poup Avançado',
    icon: 'lib/core/assets/icons/icon-modulo-avancado.png',
    color: AppColors.moduloAvancado,
  ),
};

class CardModule extends StatelessWidget {
  final int level;

  const CardModule({
    super.key,
    required this.level,
  });

  ModuleConfig get config =>
      moduleConfigs[level] ??
      const ModuleConfig(
        title: 'Módulo',
        icon: '',
        color: Colors.grey,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            config.icon,
            width: 45,
            height: 45,
          ),

          const SizedBox(width: 16),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.title.toUpperCase(),
                    style: AppTextStyles.title.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                'Módulo $level',
                style: AppTextStyles.body.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
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