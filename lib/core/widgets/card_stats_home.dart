import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class CardStatsHome extends StatelessWidget {
  final int sequenciaDias;
  final int xp;

  const CardStatsHome({
    super.key,
    required this.sequenciaDias,
    required this.xp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background, 
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              const Icon(
                Icons.local_fire_department_outlined,
                size: 35,
                color: AppColors.sequenciaHome,
              ),

              const SizedBox(width: 8),

              Text(
                '$sequenciaDias',
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.sequenciaHome,
                ),
              ),
            ],
          ),

          Row(
            children: [
              const Icon(
                Icons.star_outline,
                size: 35,
                color: AppColors.xpHome,
              ),

              const SizedBox(width: 8),

              Text(
                '$xp XP',
                style: AppTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.xpHome,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}