import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ActionItem(
            icon: Icons.edit,
            label: 'Editar Perfil',
            onTap: () {
              context.push('/edit-profile');
            },
          ),
          _ActionItem(
            icon: Icons.lock,
            label: 'Alterar Senha',
            onTap: () {
              context.push('/forgot-password');
            },
          ),
          _ActionItem(
            icon: Icons.logout,
            label: 'Sair',
            isLogout: true,
            onTap: () {
              // TODO: logout
            },
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLogout;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isLogout
            ? const Color(0xFFFFC5C0)
            : Colors.transparent,
        border: Border.all(
          color: isLogout
              ? AppColors.error
              : AppColors.textDark,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: isLogout
              ? AppColors.error
              : AppColors.textDark,
        ),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isLogout
                ? AppColors.error
                : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isLogout
              ? AppColors.error
              : AppColors.textDark,
        ),
        onTap: onTap,
      ),
    );
  }
}