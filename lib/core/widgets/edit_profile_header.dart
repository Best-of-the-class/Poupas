import 'package:flutter/material.dart';
import 'package:pomo/core/theme/app_colors.dart';

class EditProfileHeader extends StatefulWidget {
  final String imagePath;

  const EditProfileHeader({
    super.key,
    required this.imagePath,
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
  State<EditProfileHeader> createState() => _EditProfileHeaderState();
}

class _EditProfileHeaderState extends State<EditProfileHeader> {
  late String _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.imagePath;
  }

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
              /// Avatar principal
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
                  backgroundImage: AssetImage(_selectedAvatar),
                ),
              ),

              ///Botão editar
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _showAvatarModal(context),
                  child: Container(
                    width: pencilSize,
                    height: pencilSize,
                    decoration: BoxDecoration(
                      color: AppColors.selected,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
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
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Fechar",
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: Material(
                  borderRadius: BorderRadius.circular(24),
                  color: AppColors.perfilAvatar,
                  child: Container(
                    height: 550,
                    padding:
                        const EdgeInsets.fromLTRB(40, 20, 40, 0),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),

                        /// 📝 título
                        const Text(
                          'Selecione um novo avatar',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF363636),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// 🧩 GRID
                        Expanded(
                          child: GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(),
                            itemCount:
                                EditProfileHeader._availableAvatars.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),

                            itemBuilder: (context, index) {
                              final avatar = EditProfileHeader._availableAvatars[index];
                              final isSelected = avatar == _selectedAvatar;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedAvatar = avatar;
                                  });

                                  setModalState(() {});
                                  // TODO BACKEND:
                                  // Esta seleção ainda é temporária (UI only).
                                  // NÃO persistir no banco aqui.

                                },

                                child: Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [

                                    /// Borda externa (sempre mesma circunferência)
                                    CircleAvatar(
                                      radius: 65,
                                      backgroundColor: isSelected
                                          ? Colors.red
                                          : Colors.grey.shade400,
                                    ),

                                    /// Avatar interno
                                    CircleAvatar(
                                      radius: 60,
                                      backgroundImage: AssetImage(avatar),
                                    ),

                                    /// CHECK
                                    if (isSelected)
                                      Positioned(
                                        bottom: -2,
                                        right: -2,
                                        child: IgnorePointer(
                                          child: Image.asset(
                                            'lib/core/features/user_profile/presentation/assets/images/check.png',
                                            width: 40,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}