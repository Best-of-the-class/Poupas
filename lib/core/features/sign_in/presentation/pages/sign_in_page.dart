import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../widgets/background.dart';
import '../widgets/wide_button.dart';
import '../widgets/input.dart';
import '../widgets/heading_text.dart';
import '../widgets/navigate_top_corner.dart';

import '../bloc/navigation_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _userEmail = '';
  String _userName = '';

  @override
  Widget build(BuildContext context) {
    return Background(
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
                  child: NavigateTopCorner(route: 'home'),
                ),
                const HeadingText(
                  title: 'Crie uma conta',
                  subtitle:
                      'Insira seu nome e email abaixo para se cadastrar em Poupas',
                ),
                const SizedBox(height: 40),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nome Completo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Input(
                  hint: 'Insira seu nome aqui',
                  keyboardType: TextInputType.name,
                  onChanged: (value) => _userName = value,
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
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
                Builder(
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: WideButton(
                      text: 'Continuar',
                      onPress: () {
                        context.read<NavigationBloc>().requestStepOne(
                          'sign-in-password',
                          _userName,
                          _userEmail,
                        );
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
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
    );
  }
}
