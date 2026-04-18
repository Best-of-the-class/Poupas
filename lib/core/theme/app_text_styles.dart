import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static final title = GoogleFonts.baloo2(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    color: AppColors.title,
  );

  static final body = GoogleFonts.comfortaa(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static final highlight = GoogleFonts.comfortaa(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.highlight,
  );
}