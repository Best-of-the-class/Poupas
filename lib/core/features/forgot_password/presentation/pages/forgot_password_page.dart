import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../sign_in/presentation/widgets/wide_button.dart';
import '../../../sign_in/presentation/widgets/input.dart';
import '../../../sign_in/presentation/widgets/heading_text.dart';
import '../../../sign_in/presentation/widgets/navigate_top_corner.dart';
import '../../../sign_in/presentation/widgets/pop_up.dart';
import '../bloc/navigation_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _userEmail = '';

  Future<void> _showErrorPopup(BuildContext context, String message) async {
    final bloc = context.read<ForgotPasswordNavigationBloc>();
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body:
          BlocListener<
            ForgotPasswordNavigationBloc,
            ForgotPasswordNavigationState
          >(
            listenWhen: (previous, current) {
              if (current is ForgotNavigationErrorEffect &&
                  previous is ForgotNavigationErrorEffect) {
                return current.id != previous.id;
              }
              if (current is ForgotNavigationSideEffect &&
                  previous is ForgotNavigationSideEffect) {
                return current.id != previous.id;
              }
              return current is ForgotNavigationErrorEffect ||
                  current is ForgotNavigationSideEffect;
            },
            listener: (context, state) {
              if (state is ForgotNavigationSideEffect) {
                context.pushNamed(state.routeName, extra: state.arguments);
              } else if (state is ForgotNavigationErrorEffect) {
                _showErrorPopup(context, state.message);
              }
            },
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const NavigateTopCorner(route: 'login'),
                      const SizedBox(height: 40),
                      const HeadingText(
                        title: 'ALTERAR SENHA',
                        subtitle:
                            'Insira seu email abaixo para receber o código de verificação para atualizar sua senha',
                      ),
                      const SizedBox(height: 48),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Input(
                        hint: 'nome@email.com',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => _userEmail = value,
                      ),
                      const SizedBox(height: 40),
                      WideButton(
                        text: 'Enviar e-mail',
                        onPress: () {
                          context
                              .read<ForgotPasswordNavigationBloc>()
                              .requestResetStepOne(
                                'reset_password_verification',
                                _userEmail,
                              );
                        },
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
