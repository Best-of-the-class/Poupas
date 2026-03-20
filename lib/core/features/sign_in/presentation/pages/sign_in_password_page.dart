import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../../services/auth_service.dart';

import '../widgets/wide_button.dart';
import '../widgets/input.dart';
import '../widgets/heading_text.dart';
import '../widgets/navigate_top_corner.dart';
import '../widgets/background.dart';

import '../bloc/navigation_bloc.dart';
import '../bloc/validator_bloc.dart';

class SignInPagePassword extends StatefulWidget {
  final String email;
  const SignInPagePassword({super.key, required this.email});

  @override
  State<SignInPagePassword> createState() => _SignInPagePasswordState();
}

class _SignInPagePasswordState extends State<SignInPagePassword> {
  bool _obscurePassword = true;
  String _password = '';

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ValidatorBloc>(create: (context) => ValidatorBloc()),
        BlocProvider<NavigationBloc>(
          create: (context) => NavigationBloc(
            validatorBloc: BlocProvider.of<ValidatorBloc>(context),
          ),
        ),
      ],
      child: Background(
        position: ImagePosition.bottom,
        imageSize: 393,
        imagePath:
            'lib/core/features/sign_in/presentation/assets/images/poup_bottom.png',
        child: BlocListener<NavigationBloc, NavigationState>(
          listener: (context, state) {
            if (state is NavigationSideEffect) {
              context.pushNamed(state.routeName, extra: state.arguments);
            }
          },
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
                        'Insira seu email e senha abaixo para se cadastrar em Poupas',
                  ),
                  const SizedBox(height: 40),
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
                  Builder(
                    builder: (context) => SizedBox(
                      width: double.infinity,
                      child: WideButton(
                        text: 'Entrar',
                        onPress: () async {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verificando credenciais...'),
                            ),
                          );

                          bool sucesso = await _authService.login(
                            widget.email,
                            _password,
                          );

                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          if (sucesso) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Login aprovado!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            if (!context.mounted) return;
                            
                            context.goNamed('home');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Email ou senha incorretos.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                    ),
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
                          'ou continue com',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(color: Color(0xFFD9D9D9), thickness: 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: WideButton(
                      text: 'Google',
                      backgroundColor: Colors.transparent,
                      textColor: Colors.black87,
                      borderColor: const Color(0xFFE32626),
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Color(0xFFE32626),
                        size: 20,
                      ),
                      onPress: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
