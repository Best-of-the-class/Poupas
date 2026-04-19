import 'package:flutter/material.dart';

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
          primaryColor: Color(0xFF006400),
          cardBackgroundColor: Color(0xFFD4E8D1),
          iconOneBackgroundColor: Color(0xFF008000),
          iconTwoBackgroundColor: Color(0xFF004D00),
          titlePrefix: 'Módulo Fácil',
        );
      case ModuleDifficulty.medium:
        return const Module(
          primaryColor: Color(0xFFFF8C00),
          cardBackgroundColor: Color(0xFFFFEBD0),
          iconOneBackgroundColor: Color(0xFFFFA500),
          iconTwoBackgroundColor: Color(0xFFE67E22),
          titlePrefix: 'Módulo Intermediário',
        );
      case ModuleDifficulty.hard:
        return const Module(
          primaryColor: Color(0xFFD32F2F),
          cardBackgroundColor: Color(0xFFFFCDD2),
          iconOneBackgroundColor: Color(0xFFE53935),
          iconTwoBackgroundColor: Color(0xFFB71C1C),
          titlePrefix: 'Módulo Difícil',
        );
    }
  }
}
