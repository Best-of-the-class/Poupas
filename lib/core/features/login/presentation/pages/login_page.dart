import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../responsive/responsive_builder.dart';
import '../../../../widgets/pop_up.dart';
import '../../../../widgets/wide_button.dart';

import '../bloc/login_bloc.dart';
import '../layouts/login_desktop_layout.dart';
import '../layouts/login_mobile_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _showErrorPopup(
    BuildContext context,
    String message,
  ) async {
    await showDialog(
      context: context,
      builder: (_) => PopUp(
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          context.go('/home');
        }

        if (state is LoginError) {
          _showErrorPopup(context, state.message);
        }
      },
      child: const ResponsiveBuilder(
        mobile: LoginMobileLayout(),
        tablet: LoginDesktopLayout(),
        desktop: LoginDesktopLayout(),
      ),
    );
  }
}