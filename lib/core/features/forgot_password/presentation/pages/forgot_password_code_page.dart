import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../sign_in/presentati../../../../widgets/wide_button.dart';
import '../../../sign_in/presentati../../../../widgets/heading_text.dart';
import '../../../sign_in/presentati../../../../widgets/navigate_top_corner.dart';
import '../../../sign_in/presentati../../../../widgets/pop_up.dart';
import '../../../../widgets/code_input.dart';
import '../bloc/navigation_bloc.dart';

class ForgotPasswordCodePage extends StatefulWidget {
  const ForgotPasswordCodePage({super.key});

  @override
  State<ForgotPasswordCodePage> createState() => _ForgotPasswordCodePageState();
}

class _ForgotPasswordCodePageState extends State<ForgotPasswordCodePage> {
  String _verificationCode = '';

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: NavigateTopCorner(route: 'forgot_password'),
                      ),
                      const SizedBox(height: 20),
                      const HeadingText(
                        title: 'CÓDIGO DE VERIFICAÇÃO',
                        subtitle:
                            'Confira o código de verificação enviado em seu e-mail e preencha abaixo:',
                      ),
                      const SizedBox(height: 48),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Código de verificação',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      CodeInput(
                        length: 6,
                        onCompleted: (code) => _verificationCode = code,
                      ),
                      const SizedBox(height: 40),
                      WideButton(
                        text: 'Enviar código',
                        onPress: () {
                          context
                              .read<ForgotPasswordNavigationBloc>()
                              .requestResetStepTwo(
                                'reset_password_new_password',
                                _verificationCode,
                              );
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não recebeu o código? ',
                            style: TextStyle(color: Colors.black87),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'Reenviar email',
                              style: TextStyle(
                                color: Color(0xFFE32626),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
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
