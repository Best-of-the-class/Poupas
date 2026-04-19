import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';

import '../../../../widgets/background.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/input.dart';
import '../../../../widgets/heading_text.dart';
import '../../../../widgets/navigate_top_corner.dart';
import '../../../../widgets/pop_up.dart';

import '../bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userEmail = '';
  bool _obscurePassword = true;
  String _password = '';

  Future<void> _showErrorPopup(BuildContext context, String message) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: PopUp(
            title: 'Ops!',
            subtitle: message,
            buttons: [
              WideButton(
                text: 'Tentar novamente',
                onPress: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go('/home');
        } else if (state is LoginError) {
          _showErrorPopup(context, state.message);
        }
      },
      child: Background(
        position: ImagePosition.bottom,
        imageSize: 393,
        imagePath:
            'lib/core/features/sign_in/presentation/assets/images/poup_bottom.png',
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: NavigateTopCorner(route: 'welcome'),
                ),
                const HeadingText(
                  title: 'Login',
                  subtitle: 'Faça login utilizando seu email e senha',
                ),
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Input(
                  hint: 'nome@email.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => _userEmail = value,
                ),

                const SizedBox(height: 16),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Input(
                  hint: 'Sua senha',
                  obscureText: _obscurePassword,
                  onChanged: (value) => _password = value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: colorScheme.primary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),

                const SizedBox(height: 20),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.bodyMedium,
                    children: [
                      const TextSpan(text: 'Esqueceu sua senha? '),
                      TextSpan(
                        text: 'Recuperar senha',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.go('/forgot-password');
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    final isLoading = state is LoginLoading;

                    return WideButton(
                      text: isLoading ? 'Carregando...' : 'Entrar',
                      onPress: () {
                        if (isLoading) return;

                        context.read<LoginBloc>().add(
                          LoginSubmitted(_userEmail, _password),
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(child: Divider(thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '•',
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(thickness: 1)),
                  ],
                ),

                const SizedBox(height: 14),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'Ao clicar em entrar, você concorda com nossos ',
                      ),
                      TextSpan(
                        text: 'Termos de Serviço',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
