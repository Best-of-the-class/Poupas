import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pomo/core/responsive/responsive_builder.dart';
import 'package:pomo/core/widgets/pop_up.dart';
import 'package:pomo/core/widgets/wide_button.dart';
import 'package:pomo/core/theme/app_colors.dart';

import '../layouts/welcome_mobile_layout.dart';
import '../layouts/welcome_desktop_layout.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  Future<bool> _onWillPop(BuildContext context) async {
    PopUp.show(
      context,
      title: 'Sair do app',
      subtitle: 'Deseja realmente fechar o aplicativo?',
      buttons: [
        WideButton(
          text: 'Cancelar',
          onPress: () => Navigator.pop(context),
        ),
        WideButton(
          text: 'Sair',
          onPress: () => SystemNavigator.pop(),
          backgroundColor: Colors.transparent,
          textColor: AppColors.error,
          borderColor: AppColors.error,
        ),
      ],
    );

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: const ResponsiveBuilder(
        mobile: WelcomeMobileLayout(),
        tablet: WelcomeDesktopLayout(),
        desktop: WelcomeDesktopLayout(),
      ),
    );
  }
}