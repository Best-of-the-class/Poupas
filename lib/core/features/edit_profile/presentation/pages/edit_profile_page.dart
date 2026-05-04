import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pomo/core/features/user_profile/presentation/bloc/profile_bloc.dart';
import 'package:pomo/core/widgets/edit_profile_header.dart';
import 'package:pomo/core/widgets/pop_up.dart';
import 'package:pomo/core/widgets/wide_button.dart';
import 'package:pomo/core/widgets/action_result_page.dart';
import 'package:pomo/services/current_user_service.dart';

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
  final CurrentUserService _currentUser = CurrentUserService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final email = _currentUser.email;
      if (email != null && email.isNotEmpty) {
        context.read<ProfileBloc>().add(LoadProfile(email));
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      final currentEmail =
          context.read<ProfileBloc>().state.profile?.email ?? _currentUser.email;

      if (currentEmail == null || currentEmail.isEmpty) {
        PopUp.show(
          context,
          title: "Ops!",
          subtitle:
              "Não foi possível identificar o usuário atual. Faça login novamente.",
          buttons: [
            WideButton(
              text: "Fechar",
              onPress: () => Navigator.pop(context),
            ),
          ],
        );
        return;
      }

      context.read<ProfileBloc>().add(
        UpdateProfile(
          emailAtual: currentEmail,
          novoNome: _nameController.text.trim(),
          novoEmail: _emailController.text.trim(),
        ),
      );
    }
  }

 void _showDeleteAccountDialog() {
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
            // TODO: deletar conta back
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => ActionResultPage(
                  imagePath: 'lib/core/assets/images/maca-sad.png',
                  descriptionText: '''Sua conta foi apagada junto com todas as boas memórias com Poup. Aguardamos seu retorno em breve, antes que Poup decida não te perdoar mais  :(

Cadastre-se com uma nova conta quando se sentir pronto para voltar.''',
                  buttonText: 'Até logo!',
                  onButtonPressed: () {
                    context.go('/home');
                  },
                ),
              ),
              (route) => false,
            );
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
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.profile != null) {
          _nameController.text = state.profile!.nomeUsuario;
          _emailController.text = state.profile!.email;
        }

        if (state.successMessage != null) {
          context.read<ProfileBloc>().add(ClearProfileFeedback());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActionResultPage(
                imagePath:
                    'lib/core/assets/images/maca-check.png',
                descriptionText:
                    'Suas alterações foram salvas com sucesso!',
                buttonText: 'Voltar para Meu Perfil',
                onButtonPressed: () {
                  context.go('/profile');
                },
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          context.read<ProfileBloc>().add(ClearProfileFeedback());
          PopUp.show(
            context,
            title: "Ops!",
            subtitle: state.errorMessage!,
            buttons: [
              WideButton(
                text: "Fechar",
                onPress: () => Navigator.pop(context),
              ),
            ],
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF363636), size: 40),
            onPressed: () {
              context.pop();
              //context.push('/profile'); Ao fazer assim vc ta criando outra instancia de Perfil, no caso so precisaria voltar com o code acima
            },
          ),
          title: const Text(
            'Editar Perfil',
            style: TextStyle(
              color: Color(0xFF363636),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EditProfileHeader(
                    imagePath:
                        'lib/core/features/user_profile/presentation/assets/images/avatar_1.png',
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
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Salvar alterações',
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
                          onTap: _showDeleteAccountDialog,
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _EditField({
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
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
          decoration: InputDecoration(
            hintText: hint ?? label,
            prefixIcon: icon != null
                ? Icon(icon, color: AppColors.textDark)
                : null,
          ),
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
        color: isDestructive
            ? const Color(0xFFFFC5C0)
            : Colors.transparent,
        border: Border.all(
          color: isDestructive
              ? AppColors.error
              : AppColors.textDark,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 30,
          color: isDestructive
              ? AppColors.error
              : AppColors.textDark,
        ),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: isDestructive
                ? AppColors.error
                : AppColors.textDark,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: isDestructive
              ? AppColors.error
              : AppColors.textDark,
        ),
        onTap: onTap,
      ),
    );
  }
}
