import 'package:pomo/core/theme/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/heading_text.dart';
import '../../../../widgets/input.dart';
import '../../../../widgets/wide_button.dart';

import '../bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  final bool isAdmin; 

  const LoginForm({
    super.key,
    this.isAdmin = false,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email = '';
  String password = '';
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              const HeadingText(
                title: 'Login',
                subtitle: 'Faça login utilizando seu email e senha',
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email',
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 8),

              Input(
                hint: 'nome@email.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => email = v,
              ),

              const SizedBox(height: 16),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Senha',
                  style: theme.textTheme.bodyMedium,
                ),
              ),

              const SizedBox(height: 8),

              Input(
                hint: 'Sua senha',
                obscureText: obscure,
                onChanged: (v) => password = v,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscure = !obscure;
                    });
                  },
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color:AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium,
                    children: [
                      const TextSpan(
                        text: 'Esqueceu sua senha? ',
                      ),
                      TextSpan(
                        text: 'Recuperar senha',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.push('/forgot-password');
                          },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  final loading = state is LoginLoading;

                  return WideButton(
                    text: loading ? 'Carregando...' : 'Entrar',
                    onPress: () {
                      if (loading) return;

                      context.read<LoginBloc>().add(
                            LoginSubmitted(
                              email, 
                              password, 
                              isAdmin: widget.isAdmin, 
                            ),
                          );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            'Ao clicar em entrar, você concorda com nossos ',
                      ),
                      TextSpan(
                        text: 'Termos de Serviço',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                      const TextSpan(text: ' e '),
                      TextSpan(
                        text: 'Política de Privacidade',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}