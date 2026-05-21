import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:pomo/core/providers/bloc_injection.dart';
import 'package:pomo/core/widgets/pop_up.dart';
import 'package:pomo/core/widgets/wide_button.dart';
import 'package:pomo/core/widgets/action_result_page.dart';
import 'package:pomo/services/auth_service.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  Future<void> _performLogout(BuildContext context) async {
    try {
      await sl<AuthService>().logout();
    } catch (_) {
      // A limpeza local continua mesmo se o backend falhar no logout.
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('tipo');

    if (!context.mounted) {
      return;
    }

    context.read<UserProfileBloc>().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ActionResultPage(
          imagePath: 'lib/core/assets/images/maca-check.png',
          descriptionText: 'Você saiu da sua conta.',
          buttonText: 'Ir para início',
          onButtonPressed: () {
            context.go('/welcome');
          },
        ),
      ),
      (route) => false,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    PopUp.show(
      context,
      title: "Sair da conta",
      subtitle: "Tem certeza que deseja sair da sua conta?",
      buttons: [
        WideButton(
          text: "Cancelar",
          onPress: () => Navigator.pop(context),
          backgroundColor: AppColors.primary,
          textColor: AppColors.textLight,
        ),
        WideButton(
          text: "Sair",
          onPress: () async {
            Navigator.pop(context);
            await _performLogout(context);
          },
          backgroundColor: Colors.transparent,
          textColor: AppColors.error,
          borderColor: AppColors.error,
        ),
      ],
    );
  }

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
            onTap: () => _showLogoutDialog(context),
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
        color: isLogout ? const Color(0xFFFFC5C0) : Colors.transparent,
        border: Border.all(
          color: isLogout ? AppColors.error : AppColors.textDark,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 26,
          color: isLogout ? AppColors.error : AppColors.textDark,
        ),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isLogout ? AppColors.error : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isLogout ? AppColors.error : AppColors.textDark,
        ),
        onTap: onTap,
      ),
    );
  }
}
