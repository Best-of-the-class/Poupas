import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../sign_in/presentation/widgets/wide_button.dart';
import '../../../sign_in/presentation/widgets/input.dart';
import '../../../sign_in/presentation/widgets/heading_text.dart';
import '../../../sign_in/presentation/widgets/navigate_top_corner.dart';
import '../../../sign_in/presentation/widgets/pop_up.dart';
import '../bloc/navigation_bloc.dart';

class ForgotPasswordResetPage extends StatefulWidget {
  const ForgotPasswordResetPage({super.key});

  @override
  State<ForgotPasswordResetPage> createState() =>
      _ForgotPasswordResetPageState();
}

class _ForgotPasswordResetPageState extends State<ForgotPasswordResetPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String _newPassword = '';
  String _confirmPassword = '';

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
                      const NavigateTopCorner(
                        route: 'reset_password_verification',
                      ),
                      const SizedBox(height: 20),
                      const HeadingText(
                        title: 'NOVA SENHA',
                        subtitle:
                            'Crie uma nova senha segura. Ela deve ter no mínimo 6 dígitos, tendo letras, números e um caractere especial.',
                      ),
                      const SizedBox(height: 40),
                      const Text(
                        'Nova Senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Input(
                        hint: '************',
                        obscureText: _obscureNewPassword,
                        onChanged: (value) => _newPassword = value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureNewPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFE32626),
                          ),
                          onPressed: () => setState(
                            () => _obscureNewPassword = !_obscureNewPassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Confirme sua nova senha',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Input(
                        hint: '************',
                        obscureText: _obscureConfirmPassword,
                        onChanged: (value) => _confirmPassword = value,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: const Color(0xFFE32626),
                          ),
                          onPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      WideButton(
                        text: 'Salvar senha',
                        onPress: () {
                          context
                              .read<ForgotPasswordNavigationBloc>()
                              .requestResetStepThree(
                                'reset_password_confirmation',
                                _newPassword,
                                _confirmPassword,
                              );
                        },
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
