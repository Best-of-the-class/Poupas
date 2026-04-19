import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';

class EditProfileHeader extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onEditAvatar;

  const EditProfileHeader({
    super.key,
    required this.imagePath,
    this.onEditAvatar,
  });

  static const List<String> _availableAvatars = [
    'lib/core/features/user_profile/presentation/assets/images/avatar_1.png',
    'lib/core/features/user_profile/presentation/assets/images/avatar_2.png',
    'lib/core/features/user_profile/presentation/assets/images/avatar_3.png',
    'lib/core/features/user_profile/presentation/assets/images/avatar_4.png',
    'lib/core/features/user_profile/presentation/assets/images/avatar_5.png',
    'lib/core/features/user_profile/presentation/assets/images/avatar_6.png',
  ];

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 66.5;
    const double borderWidth = 4;
    const double totalDiameter = (avatarRadius + borderWidth) * 2;
    const double pencilSize = 50;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Center(
        child: SizedBox(
          width: totalDiameter,
          height: totalDiameter,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: totalDiameter,
                height: totalDiameter,
                padding: const EdgeInsets.all(borderWidth),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundImage: AssetImage(imagePath),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEditAvatar ?? () => _showAvatarModal(context),
                  child: Container(
                    width: pencilSize,
                    height: pencilSize,
                    decoration: BoxDecoration(
                      color: AppColors.selected,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.textDark,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Escolher avatar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF363636),
                ),
              ),
              const SizedBox(height: 20),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _availableAvatars.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, _availableAvatars[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE8B07A),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundImage: AssetImage(_availableAvatars[index]),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
