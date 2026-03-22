import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../widgets/wide_button.dart';
import '../widgets/input.dart';
import '../widgets/heading_text.dart';
import '../widgets/navigate_top_corner.dart';
import '../widgets/background.dart';
import '../widgets/pop_up.dart';

import '../bloc/navigation_bloc.dart';

class SignInPagePassword extends StatefulWidget {
  const SignInPagePassword({super.key});

  @override
  State<SignInPagePassword> createState() => _SignInPagePasswordState();
}

class _SignInPagePasswordState extends State<SignInPagePassword> {
  bool _obscurePassword = true;
  String _password = '';
  String _confirmPassword = '';

  void _showErrorPopup(BuildContext context, String message) {
    showGeneralDialog(
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
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state is NavigationSideEffect) {
          context.pushNamed(state.routeName, extra: state.arguments);
        }
        if (state is NavigationErrorEffect) {
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: NavigateTopCorner(route: 'sign-in'),
                ),
                const HeadingText(
                  title: 'Crie uma conta',
                  subtitle:
                      'Crie uma senha segura. Ela deve ter no mínimo 6 dígitos, tendo letras, números e um caractere especial.',
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
                      color: const Color(0xFFE32626),
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 24),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirme sua senha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Input(
                  hint: 'Repita sua senha',
                  obscureText: _obscurePassword,
                  onChanged: (value) => _confirmPassword = value,
                ),
                const SizedBox(height: 32),
                WideButton(
                  text: 'Crie uma senha',
                  onPress: () {
                    context.read<NavigationBloc>().requestStepTwo(
                      'home',
                      _password,
                      _confirmPassword,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0xFFD9D9D9), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '•',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0xFFD9D9D9), thickness: 1),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'Ao clicar em continuar, você concorda com nossos ',
                      ),
                      TextSpan(
                        text: 'Termos de Serviço',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
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
