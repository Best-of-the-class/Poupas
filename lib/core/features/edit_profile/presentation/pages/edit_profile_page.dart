import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/user_profile_bloc.dart';
import 'package:pomo/core/features/user_profile/presentation/entities/user_profile_data.dart';
import 'package:pomo/core/providers/bloc_injection.dart';
import 'package:pomo/services/auth_service.dart';
import 'package:pomo/core/widgets/edit_profile_header.dart';
import 'package:pomo/core/widgets/pop_up.dart';
import 'package:pomo/core/widgets/wide_button.dart';
import 'package:pomo/core/widgets/action_result_page.dart';

import 'package:pomo/core/theme/app_colors.dart';
import 'package:pomo/core/theme/app_text_styles.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController(text: 'Nome Usuário');
  final _emailController = TextEditingController(text: 'nomeusuario@email.com');
  final _formKey = GlobalKey<FormState>();
  int _selectedAvatarId = 1;
  bool _didPopulateForm = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileBloc>().loadProfile(force: true);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _showError(String message) async {
    await showDialog(
      context: context,
      builder: (_) => PopUp(
        title: 'Ops!',
        subtitle: message,
        buttons: [
          WideButton(text: 'Entendi', onPress: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  void _populateForm(UserProfileData profile) {
    if (_didPopulateForm) {
      return;
    }

    _nameController.text = profile.name;
    _emailController.text = profile.email;
    _selectedAvatarId = profile.avatarId;
    _didPopulateForm = true;
  }

  Future<void> _saveChanges(UserProfileData profile) async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final success = await context.read<UserProfileBloc>().updateProfile(
      currentEmail: profile.email,
      newName: _nameController.text.trim(),
      newEmail: _emailController.text.trim(),
      avatarId: _selectedAvatarId,
    );

    if (!mounted || !success) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActionResultPage(
          imagePath: 'lib/core/assets/images/maca-check.png',
          descriptionText: 'Suas alterações foram salvas com sucesso!',
          buttonText: 'Voltar para Meu Perfil',
          onButtonPressed: () {
            context.go('/profile');
          },
        ),
      ),
    );
  }

  Future<void> _deleteAccount(
    UserProfileData profile,
    String password,
  ) async {
    final trimmedPassword = password.trim();
    if (trimmedPassword.isEmpty) {
      await _showError('Informe sua senha para confirmar a exclusão da conta.');
      return;
    }

    try {
      await sl<AuthService>().deletarConta(profile.email, trimmedPassword);
    } catch (error) {
      if (!mounted) {
        return;
      }

      await _showError(error.toString().replaceFirst('Exception: ', ''));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('tipo');

    if (!mounted) {
      return;
    }

    context.read<UserProfileBloc>().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => ActionResultPage(
          imagePath: 'lib/core/assets/images/maca-sad.png',
          descriptionText:
              '''Sua conta foi excluída com sucesso.

Quando quiser voltar, será só criar uma nova conta.''',
          buttonText: 'Ir para o início',
          onButtonPressed: () {
            context.go('/welcome');
          },
        ),
      ),
      (route) => false,
    );
  }

  Future<void> _showDeleteAccountDialog(UserProfileData profile) async {
    final passwordController = TextEditingController();

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            title: Text(
              'Excluir conta',
              style: AppTextStyles.title.copyWith(color: AppColors.title),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Esta ação não pode ser desfeita. Digite sua senha para confirmar.',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha atual',
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(dialogContext);
                  await _deleteAccount(profile, passwordController.text);
                },
                child: const Text(
                  'Excluir conta',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      passwordController.dispose();
    }
  }

  void _showDeleteAccountConfirmation(UserProfileData profile) {
    PopUp.show(
      context,
      title: "Excluir conta",
      subtitle:
          "Tem certeza que deseja excluir sua conta? Esta ação não pode ser desfeita.",
      buttons: [
        WideButton(
          text: "Voltar",
          onPress: () => Navigator.pop(context),
          backgroundColor: AppColors.primary,
          textColor: AppColors.textLight,
        ),
        WideButton(
          text: "Excluir conta",
          onPress: () {
            Navigator.pop(context);
            _showDeleteAccountDialog(profile);
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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<UserProfileBloc, UserProfileState>(
          listenWhen: (previous, current) =>
              previous.errorId != current.errorId,
          listener: (context, state) {
            if (state.errorMessage != null) {
              _showError(state.errorMessage!);
            }
          },
          builder: (context, state) {
            final profile = state.profile;

            if (profile != null) {
              _populateForm(profile);
            }

            if (state.isLoading && profile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profile == null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar os dados do perfil.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    EditProfileHeader(
                      selectedAvatarId: _selectedAvatarId,
                      onAvatarSelected: (avatarId) {
                        setState(() {
                          _selectedAvatarId = avatarId;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _EditField(
                            label: 'Nome',
                            hint: 'Digite seu nome',
                            controller: _nameController,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, insira seu nome';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _EditField(
                            label: 'Email',
                            hint: 'Digite seu email',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor, insira seu email';
                              }
                              if (!value.contains('@')) {
                                return 'Email inválido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.isSaving
                                  ? null
                                  : () => _saveChanges(profile),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                state.isSaving
                                    ? 'Salvando...'
                                    : 'Salvar alterações',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.textLight,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _ActionItem(
                            icon: Icons.lock_outline,
                            label: 'Alterar Senha',
                            onTap: () {
                              context.push('/forgot-password');
                            },
                          ),
                          _ActionItem(
                            icon: Icons.delete_outline,
                            label: 'Excluir Conta',
                            isDestructive: true,
                            onTap: () => _showDeleteAccountConfirmation(profile),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _EditField({
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF363636),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.body,
          decoration: InputDecoration(hintText: hint ?? label),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDestructive ? const Color(0xFFFFC5C0) : Colors.transparent,
        border: Border.all(
          color: isDestructive ? AppColors.error : AppColors.textDark,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: isDestructive ? AppColors.error : AppColors.textDark,
        ),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isDestructive ? AppColors.error : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: isDestructive ? AppColors.error : AppColors.textDark,
        ),
        onTap: onTap,
      ),
    );
  }
}
