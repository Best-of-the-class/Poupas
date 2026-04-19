import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ModuleDifficulty { easy, medium, hard }

enum IconButtonPosition { left, right, none }

class Module {
  final Color primaryColor;
  final Color cardBackgroundColor;
  final Color iconOneBackgroundColor;
  final Color iconTwoBackgroundColor;
  final String titlePrefix;

  const Module({
    required this.primaryColor,
    required this.cardBackgroundColor,
    required this.iconOneBackgroundColor,
    required this.iconTwoBackgroundColor,
    required this.titlePrefix,
  });

  factory Module.fromDifficulty(ModuleDifficulty difficulty) {
    switch (difficulty) {
      case ModuleDifficulty.easy:
        return const Module(
          primaryColor: AppColors.moduloFacilPrimary,
          cardBackgroundColor: AppColors.moduloFacilBg,
          iconOneBackgroundColor: AppColors.moduloFacilIcon1,
          iconTwoBackgroundColor: AppColors.moduloFacilIcon2,
          titlePrefix: 'Módulo Fácil',
        );
      case ModuleDifficulty.medium:
        return const Module(
          primaryColor: AppColors.moduloMedioPrimary,
          cardBackgroundColor: AppColors.moduloMedioBg,
          iconOneBackgroundColor: AppColors.moduloMedioIcon1,
          iconTwoBackgroundColor: AppColors.moduloMedioIcon2,
          titlePrefix: 'Módulo Intermediário',
        );
      case ModuleDifficulty.hard:
        return const Module(
          primaryColor: AppColors.moduloDificilPrimary,
          cardBackgroundColor: AppColors.moduloDificilBg,
          iconOneBackgroundColor: AppColors.moduloDificilIcon1,
          iconTwoBackgroundColor: AppColors.moduloDificilIcon2,
          titlePrefix: 'Módulo Difícil',
        );
    }
  }
}
