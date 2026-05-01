import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/background.dart';
import '../../../../widgets/wide_button.dart';
import '../../../../widgets/input.dart';
import '../../../../widgets/heading_text.dart';
import '../../../../widgets/navigate_top_corner.dart';
import '../../../../widgets/pop_up.dart';
import '../bloc/navigation_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _userEmail = '';
  String _userName = '';

  Future<void> _showErrorPopup(BuildContext context, String message) async {
    final bloc = context.read<NavigationBloc>();
    if (bloc.isDialogOpen) return;
    bloc.isDialogOpen = true;

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

    bloc.isDialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<NavigationBloc, NavigationState>(
      listenWhen: (previous, current) {
        if (current is NavigationErrorEffect &&
            previous is NavigationErrorEffect) {
          return current.id != previous.id;
        }
        if (current is NavigationSideEffect &&
            previous is NavigationSideEffect) {
          return current.id != previous.id;
        }
        return current is NavigationErrorEffect ||
            current is NavigationSideEffect;
      },
      listener: (context, state) {
        if (state is NavigationSideEffect) {
          context.pushNamed(state.routeName, extra: state.arguments);
        } else if (state is NavigationErrorEffect) {
          _showErrorPopup(context, state.message);
        }
      },
      child: Background(
        position: ImagePosition.bottom,
        imageSize: 393,
        imagePath:
            'lib/core/assets/images/poup_bottom.png',
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
                  title: 'Crie uma conta',
                  subtitle:
                      'Insira seu nome e email abaixo para se cadastrar em Poupas',
                ),

                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Nome Completo',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
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

                const SizedBox(height: 32),

                WideButton(
                  text: 'Continuar',
                  onPress: () {
                    context.read<NavigationBloc>().requestStepOne(
                      'sign-in-password',
                      _userName,
                      _userEmail,
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
                        text:
                            'Ao clicar em continuar, você concorda com nossos ',
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
