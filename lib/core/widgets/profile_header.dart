import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8B07A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: CircleAvatar(
              radius: 45,
              backgroundImage: AssetImage(imagePath),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            name.toUpperCase(),
            style: AppTextStyles.title,
          ),

          const SizedBox(height: 4),

          Text(
            email,
            style: AppTextStyles.body,
          ),
        ],
      ),
    );
  }
}